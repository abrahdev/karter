#!/usr/bin/env python3
"""Translate DTC descriptions (dtc_* keys) in es.json / et.json.

Only keys whose current value is a byte-for-byte copy of the English value are
translated. Already-translated keys (e.g. curated on Weblate) are never touched,
so running this tool is idempotent and safe.

Usage:
    python3 templates/tools/translate_dtc.py            # translate es + et
    python3 templates/tools/translate_dtc.py --lang es  # only Spanish
"""

import argparse
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
I18N = ROOT / "i18n"
TOOLS = ROOT / "tools"

WORD_RE = re.compile(r"([A-Za-z]+)")


def load(path):
    return json.loads(path.read_text(encoding="utf-8"))


def dump(path, data):
    path.write_text(
        json.dumps(data, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )


def build_matchers(terms, phrases):
    words = {}
    for en, tr in terms.items():
        words[en] = tr
    multi = {}
    for phrase, tr in phrases.items():
        parts = tuple(phrase.split())
        if len(parts) == 1:
            words[parts[0]] = tr
        else:
            multi[parts] = tr
    max_len = max((len(p) for p in multi), default=0)
    multi = dict(sorted(multi.items(), key=lambda kv: (len(kv[0]), kv[0]), reverse=True))
    return words, multi, max_len


def apply_case(word, style):
    if not word:
        return word
    if style == "ALL":
        return word.upper()
    if style == "Cap":
        return word[0].upper() + word[1:]
    return word


def phrase_style(words_case):
    if all(c == "ALL" for _, c, _ in words_case):
        return "ALL"
    if words_case[0][1] == "Cap":
        return "Cap"
    return "low"


def translate_value(en_value, words, multi, max_len):
    tokens = WORD_RE.split(en_value)
    seq = []
    for idx in range(1, len(tokens), 2):
        if tokens[idx]:
            seq.append((tokens[idx], style_of(tokens[idx]), idx))
    words_only = [w.lower() for w, _, _ in seq]

    out = []
    matched_tokens = 0
    i = 0
    while i < len(seq):
        word, style, idx = seq[i]
        matched = None
        for n in range(min(max_len, len(seq) - i), 1, -1):
            key = tuple(words_only[i : i + n])
            if key in multi:
                matched = ("phrase", key, multi[key])
                break
        if matched is None and words_only[i] in words:
            matched = ("word", None, words[words_only[i]])

        out.append(tokens[idx - 1])
        if matched is None:
            out.append(word)
            i += 1
            continue

        matched_tokens += len(matched[1]) if matched[0] == "phrase" else 1
        kind, key, translation = matched
        if kind == "word":
            out.append(apply_case(translation, style))
            i += 1
        else:
            style = phrase_style(seq[i : i + len(key)])
            words_tr = translation.split(" ")
            if style == "ALL":
                out.append(" ".join(w.upper() for w in words_tr))
            else:
                out.append(
                    apply_case(words_tr[0], style)
                    + ((" " + " ".join(words_tr[1:])) if len(words_tr) > 1 else "")
                )
            i += len(key)

    out.append(tokens[-1] if tokens else "")
    return "".join(out), matched_tokens, len(seq)


def style_of(word):
    if word.isupper() and len(word) > 1:
        return "ALL"
    if word[0].isupper():
        return "Cap"
    return "low"


def translate_file(lang, en, target, terms, phrases, dry_run):
    words, multi, max_len = build_matchers(terms, phrases)
    stats = {"translated": 0, "skipped_preexisting": 0, "english_left": 0, "tokens": 0, "matched": 0}
    changed = []
    for key, en_val in en.items():
        if not key.startswith("dtc_"):
            continue
        if key not in target:
            continue
        tr_val = target[key]
        if tr_val != en_val:
            stats["skipped_preexisting"] += 1
            continue
        translated, matched, total = translate_value(en_val, words, multi, max_len)
        stats["tokens"] += total
        stats["matched"] += matched
        if translated == en_val:
            stats["english_left"] += 1
            continue
        stats["translated"] += 1
        changed.append((key, tr_val, translated))
        target[key] = translated

    print(f"[{lang}] translated={stats['translated']} "
          f"untouched_translated={stats['skipped_preexisting']} "
          f"still_english={stats['english_left']} "
          f"coverage={100*stats['matched']/max(stats['tokens'],1):.1f}%")
    if dry_run:
        for key, before, after in changed[:5]:
            print(f"  {key}: {before!r} -> {after!r}")
    return changed


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--lang", choices=["es", "et"])
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    en = load(I18N / "en.json")
    langs = ["es", "et"] if not args.lang else [args.lang]
    for lang in langs:
        target = load(I18N / f"{lang}.json")
        terms = load(TOOLS / f"dtc_terms_{lang}.json")
        phrases = load(TOOLS / f"dtc_phrases_{lang}.json")
        translate_file(lang, en, target, terms, phrases, args.dry_run)
        if not args.dry_run:
            dump(I18N / f"{lang}.json", target)
            print(f"  wrote {I18N / f'{lang}.json'}")


if __name__ == "__main__":
    main()
