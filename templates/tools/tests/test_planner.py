import json
import os
import unittest
from types import SimpleNamespace as NS

import _path  # noqa: F401  (sets up sys.path)

import planner
from generate_from_pdf.generate_from_pdf import apply_extends
from validator import build_merged_view, validate_merged


def _msg(content=None, tool_calls=None):
    return NS(content=content, tool_calls=tool_calls)


def _tool_call(name="read_file", args=None, cid="call_1"):
    return NS(
        id=cid,
        function=NS(name=name, arguments=json.dumps(args or {})),
    )


class TreeTest(unittest.TestCase):
    def test_lists_makes_and_files(self):
        tree = planner.build_tree()
        self.assertIn("bmw", tree)
        self.assertIn("yamaha", tree)
        self.assertIn("base.json", tree)
        self.assertIn("dtc.json", tree)

    def test_base_section_includes_dtc(self):
        tree = planner.build_tree()
        self.assertIn("│   ├── dtc.json", tree)


class PlanSystemTest(unittest.TestCase):
    def test_includes_schema_bases_and_tree(self):
        system = planner.build_plan_system()
        self.assertIn("powertrain", system)  # schema enum
        self.assertIn("_base/motorcycle-4t.json", system)  # leaf bases
        self.assertIn("templates/data/", system)  # tree


class ReadFileTest(unittest.TestCase):
    def test_reads_valid_path(self):
        content = planner.read_file("bmw/dtc.json")
        self.assertIn("bmw-dtc", content)

    def test_rejects_unsafe_paths(self):
        for bad in ("../schemas/template-v2.json", "/etc/passwd", "bmw/x3/..", "nope.txt"):
            out = planner.read_file(bad)
            self.assertIn("error", out)

    def test_missing_file(self):
        out = planner.read_file("nope/nope.json")
        self.assertIn("error", out)


class BaseContextTest(unittest.TestCase):
    def test_excludes_general_dtc(self):
        ctx = planner.base_templates_context()
        self.assertIn("_base/motorcycle-4t.json", ctx)
        self.assertNotIn("### _base/dtc.json", ctx)

    def test_resolved_base(self):
        rb = planner.resolved_base("_base/motorcycle-4t.json")
        ids = {i["id"] for i in rb["maintenance_items"]}
        self.assertIn("engine-oil-filter", ids)
        self.assertIn("valve-adjustment", ids)
        self.assertTrue(rb["parts"])


class PlanValidationTest(unittest.TestCase):
    def test_valid_plan(self):
        plan = {
            "make": "BMW",
            "model": "R 1250 GS",
            "base": "_base/motorcycle-4t.json",
            "target_path": "bmw/r1250gs/base.json",
        }
        self.assertEqual(planner.validate_plan(plan), [])

    def test_bad_base(self):
        plan = {"make": "X", "model": "Y", "base": "_base/dt.json", "target_path": "x/y/base.json"}
        self.assertTrue(any("invalid base" in e for e in planner.validate_plan(plan)))

    def test_null_base_allowed(self):
        plan = {"make": "X", "model": "Y", "base": None, "target_path": "x/y/base.json"}
        self.assertEqual(planner.validate_plan(plan), [])

    def test_unsafe_path(self):
        plan = {"make": "X", "model": "Y", "base": None, "target_path": "../secret.json"}
        self.assertTrue(any("unsafe target_path" in e for e in planner.validate_plan(plan)))


class PlanLoopTest(unittest.TestCase):
    def _fake_client(self, responses):
        calls = []

        def create(**kwargs):
            calls.append(kwargs)
            return NS(choices=[NS(message=responses[min(len(calls) - 1, len(responses) - 1)])])

        return NS(chat=NS(completions=NS(create=create))), calls

    def test_loop_reads_then_plans(self):
        responses = [
            _msg(tool_calls=[_tool_call(args={"path": "bmw/x3/base.json"})]),
            _msg(content=json.dumps({
                "make": "BMW", "model": "R 1250 GS",
                "base": "_base/motorcycle-4t.json",
                "target_path": "bmw/r1250gs/base.json",
                "duplicate": False,
            })),
        ]
        client, calls = self._fake_client(responses)
        plan = planner.plan(client, "m", "manual text here", "en")
        self.assertEqual(plan["target_path"], "bmw/r1250gs/base.json")
        # first call requested the tool; second carried the tool result
        self.assertEqual(len(calls), 2)
        tool_msgs = [m for m in calls[1]["messages"] if m.get("role") == "tool"]
        self.assertEqual(len(tool_msgs), 1)
        self.assertIn("bmw-x3", tool_msgs[0]["content"])

    def test_loop_strips_code_fences(self):
        responses = [
            _msg(content="```json\n{\"make\":\"X\",\"model\":\"Y\",\"base\":null,\"target_path\":\"x/y/base.json\"}\n```"),
        ]
        client, _ = self._fake_client(responses)
        plan = planner.plan(client, "m", "manual", "en")
        self.assertEqual(plan["make"], "X")


class ApplyExtendsTest(unittest.TestCase):
    def test_extends_base_and_brand_dtc(self):
        data = {"id": "bmw-r1250-gs"}
        apply_extends(data, {"base": "_base/motorcycle-4t.json", "target_path": "bmw/r1250gs/base.json"})
        self.assertEqual(data["extends"], ["_base/motorcycle-4t.json", "bmw/dtc.json"])

    def test_standalone_has_no_extends(self):
        data = {"id": "x", "extends": ["_base/car-common.json"]}
        apply_extends(data, {"base": None, "target_path": "x/y/base.json"})
        self.assertNotIn("extends", data)


class MergedValidationTest(unittest.TestCase):
    def test_valid_delta_over_base(self):
        delta = {
            "id": "test-bike",
            "meta": {"make": "Test", "model": "Bike", "author": "AI-generated", "version": "1.0.0"},
            "maintenance_items": [
                {"id": "engine-oil-filter", "interval_km": 6000, "interval_months": 12},
                {
                    "id": "chain-maintenance", "interval_km": 500,
                    "label": "Chain maintenance", "i18n_key": "maintenance_chain",
                    "description": "Clean and lubricate the chain.",
                    "parts": [{"part_id": "chain-lube", "quantity": 1}],
                },
            ],
            "parts": [
                {"id": "chain-lube", "name": "Chain lubricant", "i18n_key": "part_chain_lube",
                 "quantity": 1, "unit": "can"},
            ],
        }
        errors = validate_merged(delta, base_path="_base/motorcycle-4t.json")
        self.assertEqual(errors, [])

    def test_unknown_part_ref_reported(self):
        delta = {
            "id": "test-bike",
            "meta": {"make": "Test", "model": "Bike", "author": "AI-generated", "version": "1.0.0"},
            "maintenance_items": [
                {"id": "oil-change", "interval_km": 5000,
                 "parts": [{"part_id": "ghost-part", "quantity": 1}]},
            ],
        }
        errors = validate_merged(delta, base_path="_base/motorcycle-4t.json")
        self.assertTrue(any("ghost-part" in e for e in errors))

    def test_standalone_delta_validates(self):
        delta = {
            "id": "standalone",
            "meta": {"make": "Test", "model": "Bike", "author": "AI-generated", "version": "1.0.0"},
            "maintenance_items": [
                {"id": "oil-change", "interval_km": 5000, "interval_months": 12,
                 "label": "Oil change", "i18n_key": "maintenance_oil_change",
                 "description": "Replace the engine oil.",
                 "parts": [{"part_id": "engine-oil", "quantity": 1}]},
            ],
            "parts": [
                {"id": "engine-oil", "name": "Engine oil", "i18n_key": "part_engine_oil",
                 "quantity": 1, "unit": "L"},
            ],
        }
        errors = validate_merged(delta)
        self.assertEqual(errors, [])

    def test_merged_view_applies_base_defaults(self):
        delta = {
            "id": "test-bike",
            "meta": {"make": "Test", "model": "Bike", "author": "AI-generated", "version": "1.0.0"},
            "maintenance_items": [
                {"id": "engine-oil-filter", "interval_km": 6000},
            ],
        }
        view = build_merged_view(delta, base_path="_base/motorcycle-4t.json")
        by_id = {i["id"]: i for i in view["maintenance_items"]}
        self.assertEqual(by_id["chain"]["interval_km"], 1000)  # base default applied
        self.assertEqual(by_id["engine-oil-filter"]["interval_km"], 6000)  # overridden


if __name__ == "__main__":
    unittest.main()