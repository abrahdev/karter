import json
import os
import tempfile
import threading
import time
import unittest
from types import SimpleNamespace as NS

import _path  # noqa: F401  (sets up sys.path)

import translate_i18n as ti


def fake_client(content):
    """OpenAI-compatible client stub returning a fixed JSON string.

    Supports both streaming and non-streaming create() calls.
    """
    choice = NS(message=NS(content=content))

    def create(**kwargs):
        if kwargs.get("stream"):
            def gen():
                delta = NS(content=content)
                yield NS(choices=[NS(delta=delta)])
            return gen()
        return NS(choices=[choice])

    return NS(chat=NS(completions=NS(create=create)))


def provider(**overrides):
    p = {
        "name": "Fake",
        "model": "fake-model",
        "price_in": 1.0,
        "price_out": 2.0,
    }
    p.update(overrides)
    return p


class AbortTest(unittest.TestCase):
    def test_abort_returns_value(self):
        self.assertEqual(ti.abort("x"), "x")

    def test_abort_exits_on_back(self):
        with self.assertRaises(SystemExit):
            ti.abort(ti.BACK)


class EstimateTest(unittest.TestCase):
    def test_token_math(self):
        tok_in, tok_out, cost = ti.estimate(provider(), 100)
        self.assertEqual(tok_in, 100 * ti.TOKENS_PER_KEY)
        self.assertAlmostEqual(tok_out, 100 * ti.TOKENS_PER_KEY * 0.6)
        self.assertGreater(cost, 0)


class BuildPromptTest(unittest.TestCase):
    def test_placeholder_replaced(self):
        prompt = ti.build_prompt("es")
        self.assertIn("Spanish", prompt)
        self.assertNotIn("{lang_name}", prompt)


class TranslateBatchTest(unittest.TestCase):
    def setUp(self):
        # No sleeping between retries in tests.
        self._retries = ti.MAX_RETRIES
        self._base = ti.RETRY_BASE
        ti.MAX_RETRIES = 2
        ti.RETRY_BASE = 0

    def tearDown(self):
        ti.MAX_RETRIES = self._retries
        ti.RETRY_BASE = self._base

    def test_returns_translated_keys(self):
        items = [("k1", "one"), ("k2", "two")]
        out = {"k1": "uno", "k2": "dos"}
        client = fake_client(json.dumps(out))
        result = ti.translate_batch(client, "system", items, "m")
        self.assertEqual(result, out)

    def test_rejects_missing_key(self):
        items = [("k1", "one"), ("k2", "two")]
        client = fake_client(json.dumps({"k1": "uno"}))
        with self.assertRaises(RuntimeError):
            ti.translate_batch(client, "system", items, "m")

    def test_rejects_extra_key(self):
        items = [("k1", "one")]
        client = fake_client(json.dumps({"k1": "uno", "k3": "x"}))
        with self.assertRaises(RuntimeError):
            ti.translate_batch(client, "system", items, "m")

    def test_rejects_non_object(self):
        items = [("k1", "one")]
        client = fake_client("[1, 2, 3]")
        with self.assertRaises(RuntimeError):
            ti.translate_batch(client, "system", items, "m")

    def test_rejects_empty_value(self):
        items = [("k1", "one"), ("k2", "two")]
        client = fake_client(json.dumps({"k1": "", "k2": "dos"}))
        with self.assertRaises(RuntimeError):
            ti.translate_batch(client, "system", items, "m")

    def test_rejects_non_string_value(self):
        items = [("k1", "one")]
        client = fake_client(json.dumps({"k1": 42}))
        with self.assertRaises(RuntimeError):
            ti.translate_batch(client, "system", items, "m")


class LoadResultTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self._i18n = ti.I18N_DIR
        self._ckpt = ti.CKPT_DIR
        ti.I18N_DIR = self.tmp.name
        ti.CKPT_DIR = os.path.join(self.tmp.name, "ckpt")

    def tearDown(self):
        ti.I18N_DIR = self._i18n
        ti.CKPT_DIR = self._ckpt
        self.tmp.cleanup()

    def _write(self, path, data):
        path = os.path.join(self.tmp.name, path)
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, "w", encoding="utf-8") as fh:
            json.dump(data, fh)

    def test_missing_mode_loads_dest(self):
        self._write("es.json", {"a": "uno"})
        self.assertEqual(ti.load_result("es", "missing"), {"a": "uno"})

    def test_full_mode_ignores_dest(self):
        self._write("es.json", {"a": "uno"})
        self.assertEqual(ti.load_result("es", "full"), {})

    def test_checkpoint_merged(self):
        self._write("es.json", {"a": "uno"})
        self._write(os.path.join("ckpt", "es.json"), {"b": "dos"})
        self.assertEqual(
            ti.load_result("es", "missing"), {"a": "uno", "b": "dos"}
        )


class ProgressStub:
    """Minimal rich-Progress stand-in for the parallel runner."""

    def __init__(self):
        self.tasks = {}

    def add_task(self, description, total):
        tid = len(self.tasks)
        self.tasks[tid] = 0
        return tid

    def update(self, task, **kwargs):
        self.tasks[task] = self.tasks.get(task, 0) + kwargs.get("advance", 0)

    def remove_task(self, task):
        self.tasks.pop(task, None)


def echo_client(barrier=None, fail_keys=None, timeout=2.0, on_response=None, delay=0.0):
    """OpenAI-compatible stub that translates each requested key.

    Waits on ``barrier`` (if given) before answering, and raises for batches
    that contain any key in ``fail_keys``. Sleeps ``delay`` seconds then calls
    ``on_response()`` before answering (e.g. to set a stop event). The
    translation of ``k`` is ``"tr_" + value``.
    """
    def create(**kwargs):
        payload = json.loads(kwargs["messages"][1]["content"])

        def gen():
            if barrier is not None:
                barrier.wait(timeout=timeout)
            if fail_keys and any(k in payload for k in fail_keys):
                raise RuntimeError("boom")
            out = {k: "tr_" + v for k, v in payload.items()}
            if delay:
                time.sleep(delay)
            if on_response is not None:
                on_response()
            yield NS(choices=[NS(delta=NS(content=json.dumps(out)))])

        return gen()

    return NS(chat=NS(completions=NS(create=create)))


class ParallelRunTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self._en = ti.EN_FILE
        self._i18n = ti.I18N_DIR
        self._ckpt = ti.CKPT_DIR
        self._retries = ti.MAX_RETRIES
        self._base = ti.RETRY_BASE
        ti.EN_FILE = os.path.join(self.tmp.name, "en.json")
        ti.I18N_DIR = os.path.join(self.tmp.name, "i18n")
        ti.CKPT_DIR = os.path.join(self.tmp.name, "ckpt")
        os.makedirs(ti.I18N_DIR, exist_ok=True)
        ti.MAX_RETRIES = 2
        ti.RETRY_BASE = 0

    def tearDown(self):
        ti.EN_FILE = self._en
        ti.I18N_DIR = self._i18n
        ti.CKPT_DIR = self._ckpt
        ti.MAX_RETRIES = self._retries
        ti.RETRY_BASE = self._base
        self.tmp.cleanup()

    def _write_en(self, n):
        en = {f"k{i}": f"value {i}" for i in range(n)}
        with open(ti.EN_FILE, "w", encoding="utf-8") as fh:
            json.dump(en, fh)
        return en

    def _dest(self, lang="sv"):
        return os.path.join(ti.I18N_DIR, f"{lang}.json")

    def _ckpt_file(self, lang="sv"):
        return os.path.join(ti.CKPT_DIR, f"{lang}.json")

    def test_parallel_writes_all_keys(self):
        en = self._write_en(10)
        ti._run_parallel(
            ["sv"], "full", echo_client(), {"model": "m"}, 3, 4, ProgressStub()
        )
        with open(self._dest()) as fh:
            out = json.load(fh)
        self.assertEqual(out, {k: "tr_" + v for k, v in en.items()})
        self.assertFalse(os.path.exists(self._ckpt_file()))

    def test_single_worker_matches_sequential(self):
        en = self._write_en(7)
        ti._run_parallel(
            ["sv"], "full", echo_client(), {"model": "m"}, 2, 1, ProgressStub()
        )
        with open(self._dest()) as fh:
            out = json.load(fh)
        self.assertEqual(out, {k: "tr_" + v for k, v in en.items()})

    def test_parallelism_via_barrier(self):
        # 4 batches of 1 key + 4 workers: only truly parallel execution lets
        # all four meet at the barrier and finish.
        self._write_en(4)
        client = echo_client(barrier=threading.Barrier(4), timeout=2.0)
        ti._run_parallel(["sv"], "full", client, {"model": "m"}, 1, 4, ProgressStub())
        self.assertTrue(os.path.exists(self._dest()))

    def test_sequential_cannot_satisfy_barrier(self):
        # With a single worker the 4-party barrier times out -> batch fails ->
        # the run aborts instead of hanging.
        self._write_en(4)
        client = echo_client(barrier=threading.Barrier(4), timeout=1.0)
        with self.assertRaises(SystemExit):
            ti._run_parallel(
                ["sv"], "full", client, {"model": "m"}, 1, 1, ProgressStub()
            )

    def test_abort_on_failure_checkpoints_successes(self):
        en = self._write_en(6)
        client = echo_client(fail_keys={"k0"})
        # 6 workers so every batch is in flight: the successes finish while the
        # failing batch aborts, and the drain checkpoints them.
        with self.assertRaises(SystemExit):
            ti._run_parallel(
                ["sv"], "full", client, {"model": "m"}, 1, 6, ProgressStub()
            )
        self.assertFalse(os.path.exists(self._dest()))
        with open(self._ckpt_file()) as fh:
            saved = json.load(fh)
        self.assertNotIn("k0", saved)
        self.assertEqual(set(saved), set(en) - {"k0"})

    def test_interrupt_flushes_checkpoint(self):
        en = self._write_en(4)
        original = ti.wait

        def raise_after_wait(pending, timeout=None, return_when=None):
            original(pending, timeout=2, return_when=return_when)
            raise KeyboardInterrupt()

        ti.wait = raise_after_wait
        try:
            with self.assertRaises(KeyboardInterrupt):
                ti._run_parallel(
                    ["sv"], "full", echo_client(), {"model": "m"}, 1, 4, ProgressStub()
                )
        finally:
            ti.wait = original
        self.assertFalse(os.path.exists(self._dest()))
        with open(self._ckpt_file()) as fh:
            saved = json.load(fh)
        self.assertTrue(saved)
        self.assertTrue(set(saved) <= set(en))

    def test_stop_leaves_incomplete_language_for_resume(self):
        en = self._write_en(4)
        stop = threading.Event()
        # delay keeps worker 1 busy long enough for the queued 2nd batch to be
        # cancelled before it starts, making the outcome deterministic.
        client = echo_client(delay=0.2, on_response=stop.set)
        status = ti._run_parallel(
            ["sv"], "full", client, {"model": "m"}, 2, 1, ProgressStub(),
            stop_event=stop,
        )
        self.assertEqual(status, "stopped")
        # second batch never launched -> language incomplete -> no final file
        self.assertFalse(os.path.exists(self._dest()))
        with open(self._ckpt_file()) as fh:
            saved = json.load(fh)
        self.assertEqual(set(saved), {"k0", "k1"})
        self.assertTrue(set(saved) < set(en))

    def test_stop_finalizes_completed_language(self):
        en = self._write_en(2)
        stop = threading.Event()
        client = echo_client(delay=0.2, on_response=stop.set)
        # 1 batch covers both keys -> fully complete even though we stop after it
        status = ti._run_parallel(
            ["sv"], "full", client, {"model": "m"}, 2, 1, ProgressStub(),
            stop_event=stop,
        )
        # everything completed, so the run is effectively done
        self.assertEqual(status, "done")
        with open(self._dest()) as fh:
            out = json.load(fh)
        self.assertEqual(out, {k: "tr_" + v for k, v in en.items()})
        self.assertFalse(os.path.exists(self._ckpt_file()))

    def test_stop_finalizes_completed_languages_only(self):
        self._write_en(2)
        # pre-translate k0 for sv so it only has one batch to finish
        with open(self._dest("sv"), "w", encoding="utf-8") as fh:
            json.dump({"k0": "ya"}, fh)
        stop = threading.Event()
        client = echo_client(delay=0.2, on_response=stop.set)
        # workers=1: sv's single batch runs first and triggers the stop, so de
        # (2 batches) never starts -> incomplete, kept for resume.
        status = ti._run_parallel(
            ["sv", "de"], "missing", client, {"model": "m"}, 1, 1, ProgressStub(),
            stop_event=stop,
        )
        self.assertEqual(status, "stopped")
        with open(self._dest("sv")) as fh:
            self.assertEqual(set(json.load(fh)), {"k0", "k1"})
        self.assertFalse(os.path.exists(self._ckpt_file("sv")))
        self.assertFalse(os.path.exists(self._dest("de")))

    def test_slots_released_after_run(self):
        self._write_en(4)
        dash = ti._Dashboard(ProgressStub(), 2)
        ti._run_parallel(
            ["sv"], "full", echo_client(), {"model": "m"}, 1, 2, ProgressStub(),
            dashboard=dash,
        )
        self.assertEqual(dash.workers, [None, None])

    def test_slots_released_on_failure(self):
        self._write_en(2)
        dash = ti._Dashboard(ProgressStub(), 2)
        client = echo_client(fail_keys={"k0"})
        with self.assertRaises(SystemExit):
            ti._run_parallel(
                ["sv"], "full", client, {"model": "m"}, 1, 2, ProgressStub(),
                dashboard=dash,
            )
        self.assertEqual(dash.workers, [None, None])

    def test_complete_language_is_skipped(self):
        en = self._write_en(3)
        with open(self._dest(), "w", encoding="utf-8") as fh:
            json.dump({k: "done" for k in en}, fh)
        ti._run_parallel(
            ["sv"], "missing", echo_client(), {"model": "m"}, 1, 4, ProgressStub()
        )
        self.assertFalse(os.path.exists(self._ckpt_file()))


if __name__ == "__main__":
    unittest.main()