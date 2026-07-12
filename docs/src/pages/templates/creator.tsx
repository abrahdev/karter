import React, { useEffect, useState, useMemo, useCallback, useRef } from "react";
import Layout from "@theme/Layout";
import Link from "@docusaurus/Link";

const INDEX_URL =
  "https://raw.githubusercontent.com/abrahdev/karter/main/templates/index.json";

const RAW_BASE =
  "https://raw.githubusercontent.com/abrahdev/karter/main/templates";

const BASE_OPTIONS = [
  { value: "", label: "None (start from scratch)" },
  { value: "_base/common-all.json", label: "_base/common-all.json" },
  { value: "_base/combustion.json", label: "_base/combustion.json (gasoline)" },
  { value: "_base/diesel.json", label: "_base/diesel.json" },
  { value: "_base/electric.json", label: "_base/electric.json" },
];

const FUEL_OPTIONS = [
  { value: "", label: "Select fuel type" },
  { value: "gasoline", label: "Gasoline" },
  { value: "diesel", label: "Diesel" },
  { value: "hybrid", label: "Hybrid" },
  { value: "plugin-hybrid", label: "Plugin Hybrid" },
  { value: "electric", label: "Electric" },
  { value: "hydrogen", label: "Hydrogen" },
];

interface IMaintItem {
  id: string;
  label: string;
  i18nKey: string;
  descI18nKey: string;
  intervalKm: string;
  intervalMonths: string;
  description: string;
  remove: boolean;
}

interface IFormState {
  make: string;
  model: string;
  generation: string;
  yearsFrom: string;
  yearsTo: string;
  engineCode: string;
  engineFuel: string;
  engineDisplacement: string;
  enginePower: string;
  author: string;
  version: string;
  extends: string[];
  customExtends: string;
  items: IMaintItem[];
}

function defaultForm(): IFormState {
  return {
    make: "",
    model: "",
    generation: "",
    yearsFrom: "",
    yearsTo: "",
    engineCode: "",
    engineFuel: "",
    engineDisplacement: "",
    enginePower: "",
    author: "",
    version: "1.0.0",
    extends: [],
    customExtends: "",
    items: [],
  };
}

function toSlug(s: string): string {
  return s
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-|-$/g, "");
}

function emptyItem(): IMaintItem {
  return {
    id: "",
    label: "",
    i18nKey: "",
    descI18nKey: "",
    intervalKm: "",
    intervalMonths: "",
    description: "",
    remove: false,
  };
}

function generateBaseJson(form: IFormState): string {
  const meta: Record<string, unknown> = {
    make: form.make || "YourMake",
    model: form.model || "YourModel",
  };

  if (form.generation) meta.generation = form.generation;

  if (form.yearsFrom || form.yearsTo) {
    const from = form.yearsFrom ? parseInt(form.yearsFrom, 10) : 2000;
    const to = form.yearsTo ? parseInt(form.yearsTo, 10) : 2030;
    meta.years = [from, to];
  } else {
    meta.years = null;
  }

  if (form.engineFuel || form.engineCode || form.engineDisplacement || form.enginePower) {
    const engine: Record<string, unknown> = {};
    if (form.engineFuel) engine.fuel = form.engineFuel;
    if (form.engineCode) engine.code = form.engineCode;
    if (form.engineDisplacement) engine.displacement_cc = parseInt(form.engineDisplacement, 10);
    if (form.enginePower) engine.power_hp = parseInt(form.enginePower, 10);
    meta.engine = Object.keys(engine).length > 0 ? engine : null;
  } else {
    meta.engine = null;
  }

  meta.author = form.author || "your-username";
  meta.version = form.version || "1.0.0";

  const allExtends = [...form.extends];
  if (form.customExtends.trim()) {
    allExtends.push(form.customExtends.trim());
  }

  const maintenanceItems: Record<string, unknown>[] = [];
  for (const item of form.items) {
    if (!item.id) continue;
    if (item.remove) {
      maintenanceItems.push({ id: item.id, remove: true });
    } else {
      const entry: Record<string, unknown> = { id: item.id };
      if (item.intervalKm) entry.interval_km = parseInt(item.intervalKm, 10);
      if (item.intervalMonths) entry.interval_months = parseInt(item.intervalMonths, 10);
      if (item.label) entry.label = item.label;
      if (item.i18nKey) entry.i18n_key = item.i18nKey;
      if (item.descI18nKey) entry.desc_i18n_key = item.descI18nKey;
      if (item.description) entry.description = item.description;
      maintenanceItems.push(entry);
    }
  }

  const result: Record<string, unknown> = {
    id: `${toSlug(form.make || "yourmake")}-${toSlug(form.model || "yourmodel")}`,
    meta,
    maintenance_items: maintenanceItems,
  };

  if (allExtends.length > 0) {
    result.extends = allExtends;
  }

  return JSON.stringify(result, null, 2);
}


const STYLES: Record<string, React.CSSProperties> = {
  container: {
    maxWidth: 1200,
    margin: "0 auto",
    padding: "2rem 1rem",
  },
  title: {
    fontSize: "2rem",
    fontWeight: 700,
    marginBottom: "0.5rem",
  },
  subtitle: {
    color: "var(--ifm-color-emphasis-600)",
    marginBottom: "2rem",
  },
  layout: {
    display: "grid",
    gridTemplateColumns: "1fr 1fr",
    gap: "2rem",
    alignItems: "start",
    minWidth: 0,
  },
  panel: {
    border: "1px solid var(--ifm-color-emphasis-300)",
    borderRadius: 10,
    padding: "1.25rem",
    background: "var(--ifm-card-background-color, #f5f5f5)",
    minWidth: 0,
  },
  panelTitle: {
    fontSize: "1.1rem",
    fontWeight: 600,
    marginBottom: "1rem",
    marginTop: 0,
  },
  fieldGroup: {
    marginBottom: "1rem",
  },
  label: {
    display: "block",
    fontSize: "0.8rem",
    fontWeight: 600,
    marginBottom: "0.3rem",
    color: "var(--ifm-color-emphasis-700)",
  },
  input: {
    width: "100%",
    padding: "0.5rem 0.75rem",
    borderRadius: 6,
    border: "1px solid var(--ifm-color-emphasis-300)",
    background: "var(--ifm-background-color)",
    color: "var(--ifm-font-color-base)",
    fontSize: "0.9rem",
    boxSizing: "border-box" as const,
  },
  select: {
    width: "100%",
    padding: "0.5rem 0.75rem",
    borderRadius: 6,
    border: "1px solid var(--ifm-color-emphasis-300)",
    background: "var(--ifm-background-color)",
    color: "var(--ifm-font-color-base)",
    fontSize: "0.9rem",
    cursor: "pointer",
  },
  row: {
    display: "flex",
    gap: "0.75rem",
  },
  col: {
    flex: 1,
    minWidth: 0,
  },
  divider: {
    border: "none",
    borderTop: "1px solid var(--ifm-color-emphasis-300)",
    margin: "1rem 0",
  },
  btn: {
    padding: "0.5rem 1rem",
    borderRadius: 6,
    border: "1px solid var(--ifm-color-emphasis-300)",
    background: "var(--ifm-background-color)",
    color: "var(--ifm-font-color-base)",
    cursor: "pointer",
    fontSize: "0.85rem",
  },
  btnPrimary: {
    padding: "0.5rem 1rem",
    borderRadius: 6,
    border: "none",
    background: "var(--ifm-color-primary)",
    color: "#fff",
    cursor: "pointer",
    fontSize: "0.85rem",
    fontWeight: 600,
  },
  btnDanger: {
    padding: "0.25rem 0.6rem",
    borderRadius: 4,
    border: "1px solid var(--ifm-color-danger)",
    background: "transparent",
    color: "var(--ifm-color-danger)",
    cursor: "pointer",
    fontSize: "0.75rem",
  },
  itemCard: {
    border: "1px solid var(--ifm-color-emphasis-300)",
    borderRadius: 8,
    padding: "0.75rem",
    marginBottom: "0.5rem",
    background: "var(--ifm-background-color)",
  },
  itemHeader: {
    display: "flex",
    justifyContent: "space-between",
    alignItems: "center",
    marginBottom: "0.5rem",
  },
  itemId: {
    fontSize: "0.8rem",
    fontWeight: 600,
    color: "var(--ifm-color-emphasis-600)",
  },
  checkboxRow: {
    display: "flex",
    alignItems: "center",
    gap: "0.4rem",
    fontSize: "0.85rem",
  },
  pre: {
    background: "var(--ifm-code-background)",
    borderRadius: 6,
    padding: "1rem",
    fontSize: "0.75rem",
    overflow: "auto",
    overflowX: "auto" as const,
    maxHeight: 400,
    maxWidth: "100%",
    whiteSpace: "pre" as const,
    wordBreak: "normal" as const,
  },
  outputSection: {
    marginBottom: "1.5rem",
  },
  outputHeader: {
    display: "flex",
    justifyContent: "space-between",
    alignItems: "center",
    marginBottom: "0.5rem",
  },
  outputLabel: {
    fontSize: "0.9rem",
    fontWeight: 600,
    margin: 0,
  },
  instructions: {
    fontSize: "0.85rem",
    lineHeight: 1.7,
    color: "var(--ifm-color-emphasis-800)",
  },
  loading: {
    textAlign: "center" as const,
    padding: "4rem 0",
    color: "var(--ifm-color-emphasis-500)",
  },
};

function downloadJson(json: string, filename: string) {
  const blob = new Blob([json], { type: "application/json" });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = filename;
  a.click();
  URL.revokeObjectURL(url);
}

async function copyText(text: string): Promise<boolean> {
  try {
    await navigator.clipboard.writeText(text);
    return true;
  } catch {
    return false;
  }
}

function Input({
  label,
  value,
  onChange,
  placeholder,
  type,
}: {
  label: string;
  value: string;
  onChange: (v: string) => void;
  placeholder?: string;
  type?: string;
}) {
  return (
    <div style={STYLES.fieldGroup}>
      <label style={STYLES.label}>{label}</label>
      <input
        style={STYLES.input}
        type={type || "text"}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
      />
    </div>
  );
}

function Select({
  label,
  value,
  options,
  onChange,
}: {
  label: string;
  value: string;
  options: { value: string; label: string }[];
  onChange: (v: string) => void;
}) {
  return (
    <div style={STYLES.fieldGroup}>
      <label style={STYLES.label}>{label}</label>
      <select style={STYLES.select} value={value} onChange={(e) => onChange(e.target.value)}>
        {options.map((o) => (
          <option key={o.value} value={o.value}>
            {o.label}
          </option>
        ))}
      </select>
    </div>
  );
}

function CheckboxGroup({
  label,
  options,
  selected,
  onChange,
}: {
  label: string;
  options: { value: string; label: string }[];
  selected: string[];
  onChange: (v: string[]) => void;
}) {
  function toggle(val: string) {
    if (selected.includes(val)) {
      onChange(selected.filter((s) => s !== val));
    } else {
      onChange([...selected, val]);
    }
  }
  return (
    <div style={STYLES.fieldGroup}>
      <label style={STYLES.label}>{label}</label>
      {options.map((o) => (
        <div key={o.value} style={STYLES.checkboxRow}>
          <input
            type="checkbox"
            checked={selected.includes(o.value)}
            onChange={() => toggle(o.value)}
            id={`cb-${o.value}`}
          />
          <label htmlFor={`cb-${o.value}`} style={{ cursor: "pointer" }}>
            {o.label}
          </label>
        </div>
      ))}
    </div>
  );
}

function ItemEditor({
  item,
  index,
  onChange,
  onDelete,
}: {
  item: IMaintItem;
  index: number;
  onChange: (i: number, v: IMaintItem) => void;
  onDelete: (i: number) => void;
}) {
  function set<K extends keyof IMaintItem>(field: K, value: IMaintItem[K]) {
    const updated = { ...item, [field]: value };
    if (field === "label" && !item.remove) {
      updated.id = toSlug(value as string) || item.id;
    }
    onChange(index, updated);
  }

  const autoId = item.label ? toSlug(item.label) : item.id;

  return (
    <div style={STYLES.itemCard}>
      <div style={STYLES.itemHeader}>
        <span style={STYLES.itemId}>
          {item.remove ? <s>{autoId || "—"}</s> : autoId || "—"}
        </span>
        <button style={STYLES.btnDanger} onClick={() => onDelete(index)}>
          Delete
        </button>
      </div>
      <div style={STYLES.row}>
        <div style={STYLES.col}>
          <Input label="Label" value={item.label} onChange={(v) => set("label", v)} placeholder="e.g. Oil change" />
        </div>
        <div style={STYLES.col}>
          <Input label="ID (auto)" value={autoId} onChange={(v) => set("id", v)} placeholder="auto-from-label" />
        </div>
      </div>
      <div style={STYLES.row}>
        <div style={STYLES.col}>
          <Input label="Interval (km)" value={item.intervalKm} onChange={(v) => set("intervalKm", v)} type="number" placeholder="e.g. 10000" />
        </div>
        <div style={STYLES.col}>
          <Input label="Interval (months)" value={item.intervalMonths} onChange={(v) => set("intervalMonths", v)} type="number" placeholder="e.g. 12" />
        </div>
      </div>
      <div style={STYLES.row}>
        <div style={STYLES.col}>
          <Input label="i18n Key" value={item.i18nKey} onChange={(v) => set("i18nKey", v)} placeholder="e.g. seedIntervalOilChange" />
        </div>
        <div style={STYLES.col}>
          <Input label="Desc i18n Key" value={item.descI18nKey} onChange={(v) => set("descI18nKey", v)} placeholder="e.g. seedDescOilChange" />
        </div>
      </div>
      <Input label="Description" value={item.description} onChange={(v) => set("description", v)} placeholder="Explain what this maintenance involves..." />
      <div style={STYLES.checkboxRow}>
        <input
          type="checkbox"
          checked={item.remove}
          onChange={(e) => set("remove", e.target.checked)}
          id={`remove-${index}`}
        />
        <label htmlFor={`remove-${index}`}>Remove inherited (overrides parent)</label>
      </div>
    </div>
  );
}

export default function TemplateCreatorPage() {
  const [form, setForm] = useState<IFormState>(defaultForm);
  const [indexData, setIndexData] = useState<{ id: string; path: string; meta: Record<string, unknown> }[] | null>(null);
  const [loadingIndex, setLoadingIndex] = useState(true);
  const [selectedTemplateId, setSelectedTemplateId] = useState("");
  const [copiedBase, setCopiedBase] = useState(false);
  const baseJson = useMemo(() => generateBaseJson(form), [form]);

  useEffect(() => {
    fetch(INDEX_URL, { cache: "no-store" })
      .then((r) => {
        if (!r.ok) throw new Error(`HTTP ${r.status}`);
        return r.json();
      })
      .then((d) => {
        setIndexData(d.templates);
        setLoadingIndex(false);
      })
      .catch(() => setLoadingIndex(false));
  }, []);

  function patchForm(patch: Partial<IFormState>) {
    setForm((prev) => ({ ...prev, ...patch }));
  }

  async function loadTemplate(path: string) {
    try {
      const resp = await fetch(`${RAW_BASE}/${path}`, { cache: "no-store" });
      if (!resp.ok) return;
      const data = await resp.json();
      const meta = data.meta || {};
      const items: IMaintItem[] = (data.maintenance_items || []).map((mi: Record<string, unknown>) => ({
        id: (mi.id as string) || "",
        label: (mi.label as string) || "",
        i18nKey: (mi.i18n_key as string) || "",
        descI18nKey: (mi.desc_i18n_key as string) || "",
        intervalKm: mi.interval_km != null ? String(mi.interval_km) : "",
        intervalMonths: mi.interval_months != null ? String(mi.interval_months) : "",
        description: (mi.description as string) || "",
        remove: (mi.remove as boolean) || false,
      }));

      const extendsArr: string[] = (data.extends as string[]) || [];
      const knownBases = BASE_OPTIONS.map((o) => o.value).filter(Boolean);
      const formExtends = extendsArr.filter((e) => knownBases.includes(e));
      const customExtends = extendsArr.filter((e) => !knownBases.includes(e)).join(", ");

      const eng = meta.engine || {};
      patchForm({
        make: meta.make || "",
        model: meta.model || "",
        generation: meta.generation || "",
        yearsFrom: meta.years?.[0] != null ? String(meta.years[0]) : "",
        yearsTo: meta.years?.[1] != null ? String(meta.years[1]) : "",
        engineCode: eng.code || "",
        engineFuel: eng.fuel || "",
        engineDisplacement: eng.displacement_cc != null ? String(eng.displacement_cc) : "",
        enginePower: eng.power_hp != null ? String(eng.power_hp) : "",
        author: meta.author || "",
        version: meta.version || "1.0.0",
        extends: formExtends,
        customExtends,
        items: items.length > 0 ? items : [emptyItem()],
      });
    } catch {
      // ignore load errors
    }
  }

  function handleTemplateSelect(id: string) {
    setSelectedTemplateId(id);
    if (!id) return;
    const entry = indexData?.find((e) => e.id === id);
    if (entry) loadTemplate(entry.path);
  }

  function addItem() {
    setForm((prev) => ({ ...prev, items: [...prev.items, emptyItem()] }));
  }

  function updateItem(index: number, item: IMaintItem) {
    setForm((prev) => {
      const items = [...prev.items];
      items[index] = item;
      return { ...prev, items };
    });
  }

  function deleteItem(index: number) {
    setForm((prev) => ({
      ...prev,
      items: prev.items.filter((_, i) => i !== index),
    }));
  }

  function resetForm() {
    setForm(defaultForm());
    setSelectedTemplateId("");
  }

  function handleCopyBase() {
    copyText(baseJson).then((ok) => {
      if (ok) {
        setCopiedBase(true);
        setTimeout(() => setCopiedBase(false), 2000);
      }
    });
  }

  const forkUrl = "https://github.com/abrahdev/karter/fork";
  const makeSlug = toSlug(form.make || "yourmake");
  const modelSlug = toSlug(form.model || "yourmodel");
  const folderPath = `templates/${makeSlug}/${modelSlug}`;

  return (
    <Layout title="Template Creator" description="Create vehicle maintenance templates for Karter">
      <div style={STYLES.container}>
        <h1 style={STYLES.title}>Template Creator</h1>
        <p style={STYLES.subtitle}>
          Build a maintenance template for your vehicle. Fill out the form and we'll generate the JSON files you need.
          Then{" "}
          <Link to={forkUrl}>fork the repository</Link>, add the files, and open a pull request.
        </p>

        {loadingIndex && (
          <div style={STYLES.loading}>
            <p>Loading template index…</p>
          </div>
        )}

        {indexData && indexData.length > 0 && (
          <div style={{ ...STYLES.fieldGroup, maxWidth: 400 }}>
            <label style={STYLES.label}>Load existing template (optional)</label>
            <select
              style={STYLES.select}
              value={selectedTemplateId}
              onChange={(e) => handleTemplateSelect(e.target.value)}
            >
              <option value="">— Start from scratch —</option>
              {indexData
                .filter((t) => (t.meta as Record<string, unknown>).make !== "_base")
                .sort((a, b) => ((a.meta as Record<string, unknown>).make as string || "").localeCompare((b.meta as Record<string, unknown>).make as string || ""))
                .map((t) => {
                  const m = t.meta as Record<string, unknown>;
                  const label = `${m.make || "?"} ${m.model || "?"}${m.generation ? ` (${m.generation})` : ""}`;
                  return (
                    <option key={t.id} value={t.id}>
                      {label}
                    </option>
                  );
                })}
            </select>
          </div>
        )}

        <div style={{ ...STYLES.layout, marginTop: "1.5rem" }}>
          <div>
            <div style={STYLES.panel}>
              <h3 style={STYLES.panelTitle}>Vehicle Info</h3>
              <div style={STYLES.row}>
                <div style={STYLES.col}>
                  <Input label="Make *" value={form.make} onChange={(v) => patchForm({ make: v })} placeholder="e.g. Honda" />
                </div>
                <div style={STYLES.col}>
                  <Input label="Model *" value={form.model} onChange={(v) => patchForm({ model: v })} placeholder="e.g. Civic" />
                </div>
              </div>
              <div style={STYLES.row}>
                <div style={STYLES.col}>
                  <Input label="Generation" value={form.generation} onChange={(v) => patchForm({ generation: v })} placeholder="e.g. E210" />
                </div>
                <div style={STYLES.col}>
                  <Input label="Year from" value={form.yearsFrom} onChange={(v) => patchForm({ yearsFrom: v })} type="number" placeholder="e.g. 2021" />
                </div>
                <div style={STYLES.col}>
                  <Input label="Year to" value={form.yearsTo} onChange={(v) => patchForm({ yearsTo: v })} type="number" placeholder="e.g. 2026" />
                </div>
              </div>
            </div>

            <div style={{ ...STYLES.panel, marginTop: "1rem" }}>
              <h3 style={STYLES.panelTitle}>Engine</h3>
              <div style={STYLES.row}>
                <div style={STYLES.col}>
                  <Select label="Fuel type" value={form.engineFuel} options={FUEL_OPTIONS} onChange={(v) => patchForm({ engineFuel: v })} />
                </div>
                <div style={STYLES.col}>
                  <Input label="Engine code" value={form.engineCode} onChange={(v) => patchForm({ engineCode: v })} placeholder="e.g. K20C2" />
                </div>
              </div>
              <div style={STYLES.row}>
                <div style={STYLES.col}>
                  <Input label="Displacement (cc)" value={form.engineDisplacement} onChange={(v) => patchForm({ engineDisplacement: v })} type="number" placeholder="e.g. 1996" />
                </div>
                <div style={STYLES.col}>
                  <Input label="Power (hp)" value={form.enginePower} onChange={(v) => patchForm({ enginePower: v })} type="number" placeholder="e.g. 158" />
                </div>
              </div>
            </div>

            <div style={{ ...STYLES.panel, marginTop: "1rem" }}>
              <h3 style={STYLES.panelTitle}>Metadata & Inheritance</h3>
              <div style={STYLES.row}>
                <div style={STYLES.col}>
                  <Input label="Author *" value={form.author} onChange={(v) => patchForm({ author: v })} placeholder="Your GitHub username" />
                </div>
                <div style={STYLES.col}>
                  <Input label="Version" value={form.version} onChange={(v) => patchForm({ version: v })} placeholder="1.0.0" />
                </div>
              </div>
              <CheckboxGroup
                label="Extends (base templates to inherit from)"
                options={BASE_OPTIONS.filter((o) => o.value)}
                selected={form.extends}
                onChange={(v) => patchForm({ extends: v })}
              />
              <Input label="Custom extends (comma-separated paths)" value={form.customExtends} onChange={(v) => patchForm({ customExtends: v })} placeholder="e.g. honda/civic/base.json" />
            </div>

            <div style={{ ...STYLES.panel, marginTop: "1rem" }}>
              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "1rem" }}>
                <h3 style={{ ...STYLES.panelTitle, margin: 0 }}>Maintenance Items</h3>
                <div style={{ display: "flex", gap: "0.5rem" }}>
                  <button style={STYLES.btn} onClick={resetForm}>
                    Reset
                  </button>
                  <button style={STYLES.btnPrimary} onClick={addItem}>
                    + Add item
                  </button>
                </div>
              </div>
              {form.items.length === 0 && (
                <p style={{ fontSize: "0.85rem", color: "var(--ifm-color-emphasis-500)" }}>
                  No items yet. Click "+ Add item" to add maintenance tasks.
                </p>
              )}
              {form.items.map((item, i) => (
                <ItemEditor key={i} item={item} index={i} onChange={updateItem} onDelete={deleteItem} />
              ))}
            </div>
          </div>

          <div>
            <div style={STYLES.panel}>
              <h3 style={STYLES.panelTitle}>Generated Output</h3>

              <div style={STYLES.outputSection}>
                <div style={STYLES.outputHeader}>
                  <h4 style={STYLES.outputLabel}>base.json</h4>
                  <div style={{ display: "flex", gap: "0.5rem" }}>
                    <button style={STYLES.btn} onClick={handleCopyBase}>
                      {copiedBase ? "Copied!" : "Copy"}
                    </button>
                    <button style={STYLES.btn} onClick={() => downloadJson(baseJson, "base.json")}>
                      Download
                    </button>
                  </div>
                </div>
                <pre style={STYLES.pre}>{baseJson}</pre>
              </div>

              <hr style={STYLES.divider} />

              <div style={STYLES.outputSection}>
                <h4 style={STYLES.outputLabel}>Instructions</h4>
                <div style={STYLES.instructions}>
                  <ol style={{ paddingLeft: "1.25rem", margin: 0 }}>
                    <li>
                      <Link to={forkUrl}>Fork the repository</Link> on GitHub.
                    </li>
                    <li>
                      Clone your fork and create the folder:
                      <br />
                      <code>mkdir -p {folderPath}</code>
                    </li>
                    <li>
                      Save <strong>base.json</strong> into <code>{folderPath}/</code>.
                    </li>
                    <li>
                      Commit, push to your fork, and{" "}
                      <Link to="https://github.com/abrahdev/karter/compare">
                        open a pull request
                      </Link>
                      . The <code>templates/index.json</code> will be regenerated automatically by CI.
                    </li>
                  </ol>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </Layout>
  );
}
