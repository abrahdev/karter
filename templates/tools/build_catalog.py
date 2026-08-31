#!/usr/bin/env python3
"""Compile the karter-templates JSON source tree into a flat SQLite catalog.

Source of truth stays the human-editable, git-diffable JSON files under
templates/data (base + per-brand templates joined through `extends` chains).
This tool resolves those chains, applies strict post-merge validation, and
dumps the result into normalized SQLite tables consumed by the mobile app:

  meta                  catalog metadata (schema version, source version, built_at)
  vehicles              one row per indexable template + the general OBD pseudo-vehicle
  maintenance_items     flattened maintenance items per vehicle
  parts                 flattened parts per vehicle
  maintenance_item_parts  join: parts referenced by each maintenance item
  obd_codes             general OBD codes + per-vehicle diffs/overrides
  obd_related           DTC -> suggested maintenance items / parts

Usage:
  python build_catalog.py [--check-only] [--output PATH] [--version VERSION]
                          [--schema-check]

Exit code is non-zero when any validation error is found (schema and/or
post-merge).
"""

import argparse
import datetime
import json
import os
import sqlite3
import sys
from dataclasses import dataclass, field
from typing import Dict, List, Optional

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
DEFAULT_DATA_ROOT = os.path.join(REPO_ROOT, "templates", "data")
DEFAULT_INDEX = os.path.join(REPO_ROOT, "templates", "index.json")
DEFAULT_I18N = os.path.join(REPO_ROOT, "templates", "i18n", "en.json")
DEFAULT_SCHEMA = os.path.join(REPO_ROOT, "templates", "schemas", "template-v2.json")
DEFAULT_OUTPUT = os.path.join(REPO_ROOT, "templates", "karter-catalog.db")
SYMLINK_PATH = os.path.join(
    REPO_ROOT, "mobile", "assets", "catalog", "karter-catalog.db"
)

GENERAL_VEHICLE_ID = "general"
GENERAL_PATH = "_base/dtc.json"
SCHEMA_VERSION = "1"


@dataclass
class ResolvedItem:
    id: str
    label: str
    i18n_key: Optional[str] = None
    desc_i18n_key: Optional[str] = None
    interval_km: Optional[int] = None
    interval_months: Optional[int] = None
    description: Optional[str] = None
    parts: Dict[str, Optional[float]] = field(default_factory=dict)
    obd_codes: List[str] = field(default_factory=list)


@dataclass
class ResolvedPart:
    id: str
    name: Optional[str] = None
    i18n_key: Optional[str] = None
    oem_number: Optional[str] = None
    quantity: Optional[float] = None
    unit: Optional[str] = None
    user_reference: Optional[str] = None
    description: Optional[str] = None


@dataclass
class ResolvedDtc:
    code: str
    scope: str
    desc_i18n_key: Optional[str] = None
    description: Optional[str] = None
    related_maintenance: List[str] = field(default_factory=list)
    related_parts: List[str] = field(default_factory=list)


@dataclass
class Resolution:
    items: Dict[str, ResolvedItem] = field(default_factory=dict)
    parts: Dict[str, ResolvedPart] = field(default_factory=dict)
    dtcs: Dict[str, ResolvedDtc] = field(default_factory=dict)
    inherits_general: bool = False


# ---------------------------------------------------------------------------
# Resolution (mirrors mobile/lib/data/services/template_resolver.dart)
# ---------------------------------------------------------------------------


def _default_label(item_id: str) -> str:
    return item_id.replace("-", " ")


def _load_json(data_root: str, path: str, cache: Dict[str, dict]) -> dict:
    if path in cache:
        return cache[path]
    full = os.path.join(data_root, path)
    with open(full, encoding="utf-8") as fh:
        data = json.load(fh)
    cache[path] = data
    return data


def _resolve_item(raw: dict) -> ResolvedItem:
    return ResolvedItem(
        id=raw["id"],
        label=raw.get("label") or _default_label(raw["id"]),
        i18n_key=raw.get("i18n_key"),
        desc_i18n_key=raw.get("desc_i18n_key"),
        interval_km=raw.get("interval_km"),
        interval_months=raw.get("interval_months"),
        description=raw.get("description"),
        parts={p["part_id"]: p.get("quantity") for p in raw.get("parts") or []},
        obd_codes=list(raw.get("obd_codes") or []),
    )


def _merge_items(existing: ResolvedItem, override: ResolvedItem) -> ResolvedItem:
    return ResolvedItem(
        id=existing.id,
        label=override.label or existing.label,
        i18n_key=override.i18n_key or existing.i18n_key,
        desc_i18n_key=override.desc_i18n_key or existing.desc_i18n_key,
        interval_km=override.interval_km
        if override.interval_km is not None
        else existing.interval_km,
        interval_months=override.interval_months,
        description=override.description
        if override.description is not None
        else existing.description,
        parts=dict(existing.parts, **override.parts),
        obd_codes=list(dict.fromkeys(existing.obd_codes + override.obd_codes)),
    )


def _resolve_part(raw: dict) -> ResolvedPart:
    return ResolvedPart(
        id=raw["id"],
        name=raw.get("name"),
        i18n_key=raw.get("i18n_key"),
        oem_number=raw.get("oem_number"),
        quantity=raw.get("quantity"),
        unit=raw.get("unit"),
        user_reference=raw.get("user_reference"),
        description=raw.get("description"),
    )


def _merge_part(existing: ResolvedPart, override: ResolvedPart) -> ResolvedPart:
    return ResolvedPart(
        id=existing.id,
        name=override.name or existing.name,
        i18n_key=override.i18n_key or existing.i18n_key,
        oem_number=override.oem_number or existing.oem_number,
        quantity=override.quantity
        if override.quantity is not None
        else existing.quantity,
        unit=override.unit or existing.unit,
        user_reference=override.user_reference or existing.user_reference,
        description=override.description
        if override.description is not None
        else existing.description,
    )


def _resolve_dtc(raw: dict) -> ResolvedDtc:
    return ResolvedDtc(
        code=raw["code"],
        scope=raw["scope"],
        desc_i18n_key=raw.get("desc_i18n_key"),
        description=raw.get("description"),
        related_maintenance=list(raw.get("related_maintenance") or []),
        related_parts=list(raw.get("related_parts") or []),
    )


def _merge_dtcs(existing: ResolvedDtc, override: ResolvedDtc) -> ResolvedDtc:
    return ResolvedDtc(
        code=existing.code,
        scope=override.scope,
        desc_i18n_key=override.desc_i18n_key or existing.desc_i18n_key,
        description=override.description
        if override.description is not None
        else existing.description,
        related_maintenance=override.related_maintenance
        if override.related_maintenance
        else existing.related_maintenance,
        related_parts=override.related_parts
        if override.related_parts
        else existing.related_parts,
    )


def _apply_map(target: dict, source: dict, keep_existing: bool) -> None:
    for key, value in source.items():
        if keep_existing and key in target:
            continue
        target[key] = value


def _apply_template_items(target: Dict[str, ResolvedItem], raw_items: list) -> None:
    for raw in raw_items:
        if raw.get("remove"):
            target.pop(raw["id"], None)
            continue
        item = _resolve_item(raw)
        if raw["id"] not in target:
            target[raw["id"]] = item
        else:
            target[raw["id"]] = _merge_items(target[raw["id"]], item)


def _apply_template_parts(target: Dict[str, ResolvedPart], raw_parts: list) -> None:
    for raw in raw_parts:
        if raw.get("remove"):
            target.pop(raw["id"], None)
            continue
        part = _resolve_part(raw)
        if raw["id"] not in target:
            target[raw["id"]] = part
        else:
            target[raw["id"]] = _merge_part(target[raw["id"]], part)


def _apply_template_dtcs(target: Dict[str, ResolvedDtc], raw_dtcs: list) -> None:
    for raw in raw_dtcs:
        if raw.get("remove"):
            target.pop(raw["code"], None)
            continue
        dtc = _resolve_dtc(raw)
        if raw["code"] not in target:
            target[raw["code"]] = dtc
        else:
            target[raw["code"]] = _merge_dtcs(target[raw["code"]], dtc)


def resolve(
    path: str,
    data_root: str,
    cache: Dict[str, dict],
    visited: set,
    memo: Optional[Dict[str, Resolution]] = None,
) -> Resolution:
    if memo is None:
        memo = {}
    if path in memo:
        return memo[path]
    if path in visited:
        return Resolution()
    visited.add(path)

    raw = _load_json(data_root, path, cache)
    result = Resolution()

    for ext in raw.get("extends") or []:
        ancestor = resolve(ext, data_root, cache, visited, memo)
        _apply_map(result.items, ancestor.items, keep_existing=False)
        _apply_map(result.parts, ancestor.parts, keep_existing=False)
        _apply_map(result.dtcs, ancestor.dtcs, keep_existing=False)
        result.inherits_general = (
            result.inherits_general or ancestor.inherits_general
        )

    _apply_template_items(result.items, raw.get("maintenance_items") or [])
    _apply_template_parts(result.parts, raw.get("parts") or [])
    _apply_template_dtcs(result.dtcs, raw.get("obd_dtc_definitions") or [])

    if path == GENERAL_PATH:
        result.inherits_general = True
    memo[path] = result
    return result


# ---------------------------------------------------------------------------
# Raw-file schema validation (per-file, before any merge)
# ---------------------------------------------------------------------------


def validate_schema(data_root: str, schema_path: str, errors: List[str]) -> None:
    """Validate every templates/data/**/*.json against the JSON Schema.

    Also enforces rules that draft-07 cannot express: intra-array uniqueness
    of ids/codes and meta.years ordering. Requires the `jsonschema` package
    (see templates/tools/requirements.txt).
    """
    try:
        from jsonschema import Draft7Validator
    except ImportError as exc:
        raise SystemExit(
            "Missing dependency 'jsonschema'. Install it with:\n"
            "  pip install -r templates/tools/requirements.txt"
        ) from exc

    with open(schema_path, encoding="utf-8") as fh:
        schema = json.load(fh)
    Draft7Validator.check_schema(schema)
    validator = Draft7Validator(schema)

    for dirpath, _dirs, files in os.walk(data_root):
        for name in sorted(files):
            if not name.endswith(".json"):
                continue
            rel = os.path.relpath(os.path.join(dirpath, name), data_root)
            path = "data/" + rel.replace(os.sep, "/")

            with open(os.path.join(dirpath, name), encoding="utf-8") as fh:
                raw = json.load(fh)

            for error in sorted(
                validator.iter_errors(raw), key=lambda e: list(e.path)
            ):
                where = "/".join(str(p) for p in error.path) or "<root>"
                errors.append(f"{path}: schema error at {where}: {error.message}")

            for section, key in (
                ("parts", "id"),
                ("maintenance_items", "id"),
                ("obd_dtc_definitions", "code"),
            ):
                seen = set()
                for entry in raw.get(section) or []:
                    ident = entry.get(key)
                    if ident in seen:
                        errors.append(
                            f"{path}: duplicate {key} {ident!r} in {section}"
                        )
                    seen.add(ident)

            years = (raw.get("meta") or {}).get("years")
            if years and len(years) == 2:
                start, end = years[0], years[1]
                if (
                    start is not None
                    and end is not None
                    and start > end
                ):
                    errors.append(
                        f"{path}: meta.years start ({start}) must be <= end ({end})"
                    )


# ---------------------------------------------------------------------------
# Strict post-merge validation (no pending merge, so nothing may be missing)
# ---------------------------------------------------------------------------


def validate(res: Resolution, path: str, i18n_en: dict, errors: List[str]) -> None:
    def resolved_text(value: Optional[str], i18n_key: Optional[str]) -> Optional[str]:
        if value:
            return value
        if i18n_key:
            return i18n_en.get(i18n_key)
        return None

    for item in res.items.values():
        if item.interval_km is None or item.interval_km <= 0:
            errors.append(f"{path}: item {item.id!r} missing interval_km after merge")
        label = resolved_text(item.label, item.i18n_key)
        if not label or not label.strip():
            errors.append(f"{path}: item {item.id!r} missing label after merge")
        desc = resolved_text(item.description, item.desc_i18n_key)
        if not desc or not desc.strip():
            errors.append(f"{path}: item {item.id!r} missing description after merge")

    for part in res.parts.values():
        name = resolved_text(part.name, part.i18n_key)
        if not name or not name.strip():
            errors.append(f"{path}: part {part.id!r} missing name after merge")

    for dtc in res.dtcs.values():
        desc = resolved_text(dtc.description, dtc.desc_i18n_key)
        if not desc or not desc.strip():
            errors.append(f"{path}: dtc {dtc.code!r} missing description after merge")


# ---------------------------------------------------------------------------
# Catalog writer
# ---------------------------------------------------------------------------

_SCHEMA_SQL = """
CREATE TABLE meta (
  k TEXT PRIMARY KEY,
  v TEXT NOT NULL
);

CREATE TABLE vehicles (
  id TEXT PRIMARY KEY,
  path TEXT NOT NULL,
  kind TEXT NOT NULL,
  make TEXT NOT NULL,
  model TEXT NOT NULL,
  generation TEXT,
  year_from INTEGER,
  year_to INTEGER,
  engine_code TEXT,
  fuel TEXT,
  powertrain TEXT,
  displacement_cc INTEGER,
  power_hp INTEGER,
  author TEXT,
  version TEXT,
  market_json TEXT,
  sources_json TEXT,
  specificity INTEGER NOT NULL DEFAULT 0,
  item_count INTEGER NOT NULL DEFAULT 0,
  inherits_general INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX vehicles_make_idx ON vehicles(make);
CREATE INDEX vehicles_make_model_idx ON vehicles(make, model);

CREATE TABLE maintenance_items (
  vehicle_id TEXT NOT NULL,
  id TEXT NOT NULL,
  label TEXT NOT NULL,
  i18n_key TEXT,
  desc_i18n_key TEXT,
  interval_km INTEGER NOT NULL,
  interval_months INTEGER,
  description TEXT NOT NULL,
  PRIMARY KEY (vehicle_id, id)
);
CREATE INDEX maintenance_items_vehicle_idx ON maintenance_items(vehicle_id);

CREATE TABLE parts (
  vehicle_id TEXT NOT NULL,
  id TEXT NOT NULL,
  name TEXT NOT NULL,
  i18n_key TEXT,
  oem_number TEXT NOT NULL,
  quantity REAL,
  unit TEXT,
  description TEXT,
  PRIMARY KEY (vehicle_id, id)
);
CREATE INDEX parts_vehicle_idx ON parts(vehicle_id);

CREATE TABLE maintenance_item_parts (
  vehicle_id TEXT NOT NULL,
  maintenance_item_id TEXT NOT NULL,
  part_id TEXT NOT NULL,
  quantity REAL,
  PRIMARY KEY (vehicle_id, maintenance_item_id, part_id)
);

CREATE TABLE obd_codes (
  vehicle_id TEXT NOT NULL,
  code TEXT NOT NULL,
  scope TEXT NOT NULL,
  desc_i18n_key TEXT,
  description TEXT NOT NULL,
  removed INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (vehicle_id, code)
);
CREATE INDEX obd_codes_vehicle_idx ON obd_codes(vehicle_id, code);

CREATE TABLE obd_related (
  vehicle_id TEXT NOT NULL,
  code TEXT NOT NULL,
  related_type TEXT NOT NULL,
  related_id TEXT NOT NULL,
  PRIMARY KEY (vehicle_id, code, related_type, related_id)
);
CREATE INDEX obd_related_vehicle_idx ON obd_related(vehicle_id, code);
"""


def _specificity(meta: dict) -> int:
    score = 0
    if meta.get("generation"):
        score += 1
    engine = meta.get("engine")
    if engine:
        score += 1
        if engine.get("code"):
            score += 1
        if engine.get("fuel"):
            score += 1
    if meta.get("years"):
        score += 1
    return score


def _same_dtc(a: ResolvedDtc, b: ResolvedDtc) -> bool:
    return (
        a.scope == b.scope
        and a.desc_i18n_key == b.desc_i18n_key
        and a.description == b.description
    )


def write_catalog(
    output: str,
    index: dict,
    general: Resolution,
    vehicles: Dict[str, tuple],
    i18n_en: dict,
    catalog_version: str,
) -> None:
    os.makedirs(os.path.dirname(output) or ".", exist_ok=True)
    if os.path.exists(output):
        os.remove(output)
    db = sqlite3.connect(output)
    try:
        db.execute("PRAGMA page_size = 4096")
        db.executescript(_SCHEMA_SQL)

        db.execute(
            "INSERT INTO meta(k, v) VALUES (?, ?)",
            ("schema_version", SCHEMA_VERSION),
        )
        db.execute(
            "INSERT INTO meta(k, v) VALUES (?, ?)",
            ("catalog_version", catalog_version),
        )
        db.execute(
            "INSERT INTO meta(k, v) VALUES (?, ?)",
            ("built_at", datetime.datetime.now(datetime.timezone.utc).isoformat()),
        )

        db.execute(
            "INSERT INTO vehicles(id, path, kind, make, model, item_count, inherits_general) "
            "VALUES (?, ?, ?, ?, ?, ?, ?)",
            (
                GENERAL_VEHICLE_ID,
                "data/" + GENERAL_PATH,
                "general",
                "_base",
                "OBD-II codes",
                0,
                1,
            ),
        )

        for vid in sorted(vehicles):
            entry, res = vehicles[vid]
            meta = entry["meta"]
            years = meta.get("years") or []
            engine = meta.get("engine") or {}
            db.execute(
                "INSERT INTO vehicles("
                "id, path, kind, make, model, generation, year_from, year_to, "
                "engine_code, fuel, powertrain, displacement_cc, power_hp, "
                "author, version, market_json, sources_json, "
                "specificity, item_count, inherits_general) "
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                (
                    entry["id"],
                    entry["path"],
                    "vehicle",
                    meta.get("make", ""),
                    meta.get("model", ""),
                    meta.get("generation"),
                    years[0] if len(years) > 0 else None,
                    years[1] if len(years) > 1 else None,
                    engine.get("code"),
                    engine.get("fuel"),
                    engine.get("powertrain"),
                    engine.get("displacement_cc"),
                    engine.get("power_hp"),
                    meta.get("author", ""),
                    meta.get("version", ""),
                    json.dumps(meta.get("market")) if meta.get("market") else None,
                    json.dumps(meta.get("sources")) if meta.get("sources") else None,
                    _specificity(meta),
                    len(res.items),
                    1 if res.inherits_general else 0,
                ),
            )

            for item in res.items.values():
                db.execute(
                    "INSERT INTO maintenance_items("
                    "vehicle_id, id, label, i18n_key, desc_i18n_key, "
                    "interval_km, interval_months, description) "
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
                    (
                        entry["id"],
                        item.id,
                        item.label,
                        item.i18n_key,
                        item.desc_i18n_key,
                        item.interval_km,
                        item.interval_months,
                        item.description or "",
                    ),
                )
                for part_id, quantity in item.parts.items():
                    db.execute(
                        "INSERT INTO maintenance_item_parts("
                        "vehicle_id, maintenance_item_id, part_id, quantity) "
                        "VALUES (?, ?, ?, ?)",
                        (entry["id"], item.id, part_id, quantity),
                    )

            for part in res.parts.values():
                db.execute(
                    "INSERT INTO parts("
                    "vehicle_id, id, name, i18n_key, oem_number, quantity, unit, description) "
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
                    (
                        entry["id"],
                        part.id,
                        part.name or "",
                        part.i18n_key,
                        part.oem_number or "",
                        part.quantity,
                        part.unit,
                        part.description,
                    ),
                )

            general_set = general.dtcs
            if res.inherits_general:
                for code, dtc in res.dtcs.items():
                    base = general_set.get(code)
                    if base is None or not _same_dtc(base, dtc):
                        db.execute(
                            "INSERT INTO obd_codes("
                            "vehicle_id, code, scope, desc_i18n_key, description) "
                            "VALUES (?, ?, ?, ?, ?)",
                            (
                                entry["id"],
                                dtc.code,
                                dtc.scope,
                                dtc.desc_i18n_key,
                                dtc.description or "",
                            ),
                        )
                for code in general_set:
                    if code not in res.dtcs:
                        db.execute(
                            "INSERT INTO obd_codes("
                            "vehicle_id, code, scope, desc_i18n_key, description, removed) "
                            "VALUES (?, ?, ?, ?, ?, 1)",
                            (entry["id"], code, "", None, ""),
                        )
            else:
                for dtc in res.dtcs.values():
                    db.execute(
                        "INSERT INTO obd_codes("
                        "vehicle_id, code, scope, desc_i18n_key, description) "
                        "VALUES (?, ?, ?, ?, ?)",
                        (
                            entry["id"],
                            dtc.code,
                            dtc.scope,
                            dtc.desc_i18n_key,
                            dtc.description or "",
                        ),
                    )

            for code, dtc in res.dtcs.items():
                for related in dtc.related_maintenance:
                    db.execute(
                        "INSERT INTO obd_related(vehicle_id, code, related_type, related_id) "
                        "VALUES (?, ?, 'maintenance', ?)",
                        (entry["id"], code, related),
                    )
                for related in dtc.related_parts:
                    db.execute(
                        "INSERT INTO obd_related(vehicle_id, code, related_type, related_id) "
                        "VALUES (?, ?, 'part', ?)",
                        (entry["id"], code, related),
                    )

        for code, dtc in general.dtcs.items():
            db.execute(
                "INSERT INTO obd_codes("
                "vehicle_id, code, scope, desc_i18n_key, description) "
                "VALUES (?, ?, ?, ?, ?)",
                (
                    GENERAL_VEHICLE_ID,
                    dtc.code,
                    dtc.scope,
                    dtc.desc_i18n_key,
                    dtc.description or "",
                ),
            )

        db.commit()
        db.execute("VACUUM")
        integrity = db.execute("PRAGMA integrity_check").fetchone()[0]
        if integrity != "ok":
            raise RuntimeError(f"SQLite integrity_check failed: {integrity}")
    finally:
        db.close()


def _self_check(output: str, general: Resolution) -> None:
    db = sqlite3.connect(output)
    try:
        def one(query, params=()):
            row = db.execute(query, params).fetchone()
            return row[0] if row else None

        vehicles = one("SELECT COUNT(*) FROM vehicles")
        general_codes = one(
            "SELECT COUNT(*) FROM obd_codes WHERE vehicle_id = ? AND removed = 0",
            (GENERAL_VEHICLE_ID,),
        )
        total_codes = one("SELECT COUNT(*) FROM obd_codes")
        corolla_oil = one(
            "SELECT interval_km FROM maintenance_items "
            "WHERE vehicle_id = 'toyota-corolla' AND id = 'oil-change'"
        )
        corolla_belt = one(
            "SELECT COUNT(*) FROM maintenance_items "
            "WHERE vehicle_id = 'toyota-corolla' AND id = 'timing-belt'"
        )
        hybrid_filter = one(
            "SELECT COUNT(*) FROM maintenance_items "
            "WHERE vehicle_id = 'toyota-corolla-e210-1-8-hybrid' AND id = 'hybrid-battery-filter'"
        )
        toyota_p1100 = one(
            "SELECT COUNT(*) FROM obd_codes WHERE code = 'P1100' "
            "AND vehicle_id IN (SELECT id FROM vehicles WHERE make = 'Toyota')"
        )
        assert vehicles == len(index_templates) + 1, f"vehicles={vehicles}"
        assert general_codes == len(general.dtcs), f"general={general_codes}"
        assert corolla_oil == 15000, f"corolla oil-change={corolla_oil}"
        assert corolla_belt == 0, "timing-belt should be removed for Corolla"
        assert hybrid_filter == 1, "hybrid-battery-filter missing for e210"
        assert toyota_p1100 and toyota_p1100 > 0, "toyota P1100 missing"
        print(
            f"OK vehicles={vehicles} general_dtc={general_codes} "
            f"total_obd_rows={total_codes} corolla_oil={corolla_oil}"
        )
    finally:
        db.close()


index_templates = []


def _ensure_symlink(output: str) -> None:
    link_dir = os.path.dirname(SYMLINK_PATH)
    target = os.path.relpath(output, link_dir)
    os.makedirs(link_dir, exist_ok=True)
    if os.path.islink(SYMLINK_PATH):
        if os.readlink(SYMLINK_PATH) == target:
            return
        os.remove(SYMLINK_PATH)
    elif os.path.exists(SYMLINK_PATH):
        os.remove(SYMLINK_PATH)
    try:
        os.symlink(target, SYMLINK_PATH)
    except OSError as exc:
        raise SystemExit(
            f"Failed to create symlink {SYMLINK_PATH} -> {target}: {exc}\n"
            "Enable symlink support (e.g. Windows Developer Mode) and retry."
        )
    print(f"Symlinked {SYMLINK_PATH} -> {target}")


def main(argv: Optional[List[str]] = None) -> int:
    global index_templates
    parser = argparse.ArgumentParser(description="Compile karter-templates to SQLite catalog")
    parser.add_argument("--check-only", action="store_true", help="resolve and validate without writing")
    parser.add_argument("--output", default=DEFAULT_OUTPUT, help="output .db path")
    parser.add_argument("--version", default=None, help="catalog_version (defaults to index generated_at)")
    parser.add_argument("--data-root", default=DEFAULT_DATA_ROOT)
    parser.add_argument("--index", default=DEFAULT_INDEX)
    parser.add_argument("--i18n", default=DEFAULT_I18N)
    parser.add_argument(
        "--schema",
        default=DEFAULT_SCHEMA,
        help="JSON Schema that validates the raw template files",
    )
    parser.add_argument(
        "--schema-check",
        action="store_true",
        help="validate all templates/data/**/*.json against the JSON Schema",
    )
    args = parser.parse_args(argv)

    with open(args.index, encoding="utf-8") as fh:
        index = json.load(fh)
    index_templates = index["templates"]
    catalog_version = args.version or index.get("generated_at") or "unknown"

    with open(args.i18n, encoding="utf-8") as fh:
        i18n_en = json.load(fh)

    cache: Dict[str, dict] = {}
    errors: List[str] = []
    if args.schema_check:
        validate_schema(args.data_root, args.schema, errors)
    general = resolve(GENERAL_PATH, args.data_root, cache, set())
    validate(general, "data/" + GENERAL_PATH, i18n_en, errors)

    vehicles: Dict[str, tuple] = {}
    for entry in index_templates:
        rel = entry["path"]
        if not rel.startswith("data/"):
            errors.append(f"{rel}: index path must start with 'data/'")
            continue
        path = rel[len("data/"):]
        res = resolve(path, args.data_root, cache, set())
        validate(res, rel, i18n_en, errors)
        if entry["id"] in vehicles:
            errors.append(f"{entry['id']}: duplicate vehicle id")
        vehicles[entry["id"]] = (entry, res)

    if errors:
        print(f"FAILED with {len(errors)} validation error(s):", file=sys.stderr)
        for err in errors[:100]:
            print(f"  - {err}", file=sys.stderr)
        if len(errors) > 100:
            print(f"  ... and {len(errors) - 100} more", file=sys.stderr)
        return 1

    if args.check_only:
        print(
            f"OK (check-only) vehicles={len(vehicles)} "
            f"general_dtc={len(general.dtcs)} items={sum(len(v[1].items) for v in vehicles.values())}"
        )
        return 0

    write_catalog(
        args.output,
        index,
        general,
        vehicles,
        i18n_en,
        catalog_version,
    )
    _self_check(args.output, general)
    _ensure_symlink(args.output)
    size = os.path.getsize(args.output)
    print(f"Wrote {args.output} ({size / 1024 / 1024:.2f} MB, catalog_version={catalog_version})")
    return 0


if __name__ == "__main__":
    sys.exit(main())
