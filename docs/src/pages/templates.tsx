import React, { useEffect, useState, useMemo, useRef } from "react";
import Layout from "@theme/Layout";
import Link from "@docusaurus/Link";

const INDEX_URL =
  "https://raw.githubusercontent.com/abrahdev/karter/main/templates/index.json";

interface Engine {
  fuel?: string;
  displacement_cc?: number;
}

interface Meta {
  make: string;
  model: string;
  generation?: string;
  years?: [number, number] | null;
  engine?: Engine | null;
  author: string;
  version: string;
}

interface TemplateEntry {
  id: string;
  path: string;
  meta: Meta;
  item_count: number;
  extends: string[];
}

interface IndexData {
  schema_version: string;
  generated_at: string;
  templates: TemplateEntry[];
}

const FUEL_LABELS: Record<string, string> = {
  gasoline: "Gasoline",
  diesel: "Diesel",
  hybrid: "Hybrid",
  electric: "Electric",
  hydrogen: "Hydrogen",
  "plugin-hybrid": "Plugin Hybrid",
};

const FUEL_COLORS: Record<string, string> = {
  gasoline: "#eab308",
  diesel: "#2563eb",
  hybrid: "#16a34a",
  electric: "#8b5cf6",
  hydrogen: "#06b6d4",
  "plugin-hybrid": "#0891b2",
};

const STYLES: Record<string, React.CSSProperties> = {
  container: {
    maxWidth: 1000,
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
  filters: {
    display: "flex",
    flexWrap: "wrap" as const,
    gap: "0.75rem",
    marginBottom: "2rem",
    padding: "1rem",
    borderRadius: 8,
    border: "1px solid var(--ifm-color-emphasis-300)",
    background: "var(--ifm-card-background-color, #f5f5f5)",
  },
  filterGroup: {
    display: "flex",
    flexDirection: "column" as const,
    gap: "0.25rem",
    flex: "1 1 180px",
    minWidth: 140,
  },
  label: {
    fontSize: "0.75rem",
    fontWeight: 600,
    textTransform: "uppercase" as const,
    letterSpacing: "0.5px",
    color: "var(--ifm-color-emphasis-600)",
  },
  select: {
    padding: "0.5rem 0.75rem",
    borderRadius: 6,
    border: "1px solid var(--ifm-color-emphasis-300)",
    background: "var(--ifm-background-color)",
    color: "var(--ifm-font-color-base)",
    fontSize: "0.9rem",
    cursor: "pointer",
  },

  card: {
    border: "1px solid var(--ifm-color-emphasis-300)",
    borderRadius: 10,
    padding: "1.25rem",
    marginBottom: "0.75rem",
    background: "var(--ifm-card-background-color, #f5f5f5)",
    transition: "border-color 0.2s, transform 0.2s",
    cursor: "pointer",
  },
  cardHeader: {
    display: "flex",
    justifyContent: "space-between",
    alignItems: "flex-start",
    marginBottom: "0.5rem",
  },
  cardTitle: {
    fontSize: "1.1rem",
    fontWeight: 600,
    margin: 0,
  },
  badge: {
    display: "inline-flex",
    alignItems: "center",
    gap: "0.3rem",
    padding: "0.2rem 0.6rem",
    borderRadius: 999,
    fontSize: "0.75rem",
    fontWeight: 600,
    color: "#fff",
  },
  cardBody: {
    fontSize: "0.85rem",
    color: "var(--ifm-color-emphasis-700)",
    lineHeight: 1.6,
  },
  cardFooter: {
    display: "flex",
    justifyContent: "space-between",
    alignItems: "center",
    marginTop: "0.75rem",
    fontSize: "0.8rem",
    color: "var(--ifm-color-emphasis-500)",
  },
  count: {
    fontSize: "0.8rem",
    color: "var(--ifm-color-emphasis-500)",
  },
  loading: {
    textAlign: "center" as const,
    padding: "4rem 0",
    color: "var(--ifm-color-emphasis-500)",
  },
  reset: {
    padding: "0.5rem 1rem",
    borderRadius: 6,
    border: "1px solid var(--ifm-color-emphasis-300)",
    background: "var(--ifm-background-color)",
    color: "var(--ifm-font-color-base)",
    cursor: "pointer",
    fontSize: "0.85rem",
    alignSelf: "flex-end",
    marginBottom: "0.25rem",
  },
};

function Modal({
  t,
  onClose,
}: {
  t: TemplateEntry;
  onClose: () => void;
}) {
  const m = t.meta;
  const fuel = m.engine?.fuel;

  const years =
    m.years ? `${m.years[0]}–${m.years[1]}` : null;
  const displacement = m.engine?.displacement_cc
    ? `${m.engine.displacement_cc}cc`
    : null;

  const sourceUrl = `https://github.com/abrahdev/karter/blob/main/templates/data/${t.path}`;

  const fields: { label: string; value: string | null }[] = [
    { label: "ID", value: t.id },
    { label: "Make", value: m.make },
    { label: "Model", value: m.model },
    { label: "Generation", value: m.generation ?? null },
    { label: "Years", value: years },
    { label: "Displacement", value: displacement },
    { label: "Fuel", value: fuel ? FUEL_LABELS[fuel] || fuel : null },
    { label: "Author", value: m.author },
    { label: "Version", value: m.version },
    { label: "Items", value: String(t.item_count) },
    {
      label: "Extends",
      value: t.extends.length > 0 ? t.extends.join(", ") : null,
    },
  ];

  return (
    <div
      onClick={onClose}
      style={{
        position: "fixed",
        inset: 0,
        zIndex: 9999,
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        background: "rgba(0,0,0,0.6)",
        backdropFilter: "blur(2px)",
        padding: "1rem",
      }}
    >
      <div
        onClick={(e) => e.stopPropagation()}
        className="template-bg"
        style={{
          maxWidth: 560,
          width: "100%",
          borderRadius: 12,
          border: "1px solid var(--ifm-color-emphasis-300)",
          background: "var(--ifm-background-color)",
          padding: 0,
          overflow: "hidden",
        }}
      >
        <div
          style={{
            display: "flex",
            justifyContent: "space-between",
            alignItems: "flex-start",
            padding: "1.5rem 1.5rem 0.75rem",
          }}
        >
          <div style={{ flex: 1, minWidth: 0 }}>
            <h2 style={{ margin: 0, fontSize: "1.25rem", color: "var(--ifm-font-color-base)" }}>
              {m.make} {m.model}
              {m.generation ? ` ${m.generation}` : ""}
            </h2>
            {fuel && (
              <span
                style={{
                  ...STYLES.badge,
                  backgroundColor: FUEL_COLORS[fuel] || "#666",
                  marginTop: "0.4rem",
                }}
              >
                {FUEL_LABELS[fuel] || fuel}
              </span>
            )}
          </div>
          <button
            onClick={onClose}
            style={{
              background: "none",
              border: "none",
              fontSize: "1.5rem",
              cursor: "pointer",
              color: "var(--ifm-color-emphasis-500)",
              lineHeight: 1,
              padding: "0.25rem",
            }}
          >
            ✕
          </button>
        </div>

        <div style={{ borderTop: "1px solid var(--ifm-color-emphasis-200)" }}>
          {fields.map(
            (f) =>
              f.value && (
                <div
                  key={f.label}
                  style={{
                    display: "flex",
                    padding: "0.65rem 1.5rem",
                    borderBottom: "1px solid var(--ifm-color-emphasis-200)",
                    fontSize: "0.875rem",
                  }}
                >
                  <span
                    style={{
                      fontWeight: 600,
                      color: "var(--ifm-color-emphasis-600)",
                      width: 120,
                      flexShrink: 0,
                    }}
                  >
                    {f.label}
                  </span>
                  <span
                    style={{
                      color: "var(--ifm-font-color-base)",
                      wordBreak: "break-word",
                    }}
                  >
                    {f.value}
                  </span>
                </div>
              )
          )}
        </div>

        <div
          style={{
            padding: "1rem 1.5rem",
            display: "flex",
            justifyContent: "space-between",
            alignItems: "center",
          }}
        >
          <Link
            to={sourceUrl}
            style={{
              fontSize: "0.8rem",
              color: "var(--ifm-color-primary)",
              textDecoration: "none",
            }}
          >
            View source on GitHub →
          </Link>
          <button
            onClick={onClose}
            style={{
              padding: "0.5rem 1.25rem",
              borderRadius: 6,
              border: "1px solid var(--ifm-color-emphasis-300)",
              background: "var(--ifm-card-background-color)",
              color: "var(--ifm-font-color-base)",
              cursor: "pointer",
              fontSize: "0.875rem",
            }}
          >
            Close
          </button>
        </div>
      </div>
    </div>
  );
}

function SelectDropdown({
  value,
  options,
  onChange,
  placeholder,
  disabled,
  getDotColor,
  getLabel,
}: {
  value: string;
  options: string[];
  onChange: (v: string) => void;
  placeholder: string;
  disabled?: boolean;
  getDotColor?: (v: string) => string | undefined;
  getLabel?: (v: string) => string;
}) {
  const [open, setOpen] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handler = (e: MouseEvent) => {
      if (ref.current && !ref.current.contains(e.target as Node)) {
        setOpen(false);
      }
    };
    document.addEventListener("mousedown", handler);
    return () => document.removeEventListener("mousedown", handler);
  }, []);

  const display = value
    ? getLabel
      ? getLabel(value)
      : value
    : placeholder;

  return (
    <div
      ref={ref}
      style={{
        position: "relative",
        width: "100%",
        opacity: disabled ? 0.45 : 1,
        pointerEvents: disabled ? "none" : "auto",
      }}
    >
      <button
        type="button"
        onClick={() => setOpen(!open)}
        className="template-bg"
        style={{
          ...STYLES.select,
          width: "100%",
          display: "flex",
          alignItems: "center",
          gap: "0.5rem",
          textAlign: "left",
        }}
      >
        {value && getDotColor?.(value) && (
          <span
            style={{
              width: 10,
              height: 10,
              borderRadius: "50%",
              backgroundColor: getDotColor(value) || "#666",
              flexShrink: 0,
            }}
          />
        )}
        <span style={{ flex: 1 }}>{display}</span>
        <span style={{ fontSize: "0.65rem", color: "var(--ifm-color-emphasis-500)" }}>
          ▾
        </span>
      </button>

      {open && (
        <div
          className="template-bg"
          style={{
            position: "absolute",
            top: "100%",
            left: 0,
            right: 0,
            marginTop: 4,
            borderRadius: 8,
            border: "1px solid var(--ifm-color-emphasis-300)",
            background: "var(--ifm-background-color)",
            zIndex: 100,
            overflow: "hidden",
          }}
        >
          <div
            onClick={() => {
              onChange("");
              setOpen(false);
            }}
            style={{
              padding: "0.5rem 0.75rem",
              cursor: "pointer",
              fontSize: "0.875rem",
              color: "var(--ifm-color-emphasis-600)",
            }}
          >
            {placeholder}
          </div>
          {options.map((opt) => {
            const label = getLabel ? getLabel(opt) : opt;
            const dotColor = getDotColor?.(opt);
            return (
              <div
                key={opt}
                onClick={() => {
                  onChange(opt);
                  setOpen(false);
                }}
                style={{
                  display: "flex",
                  alignItems: "center",
                  gap: "0.5rem",
                  padding: "0.5rem 0.75rem",
                  cursor: "pointer",
                  fontSize: "0.875rem",
                  color: "var(--ifm-font-color-base)",
                  borderTop: "1px solid var(--ifm-color-emphasis-200)",
                }}
                onMouseEnter={(e) => {
                  e.currentTarget.style.background = "var(--ifm-hover-overlay)";
                }}
                onMouseLeave={(e) => {
                  e.currentTarget.style.background = "transparent";
                }}
              >
                {dotColor && (
                  <span
                    style={{
                      width: 10,
                      height: 10,
                      borderRadius: "50%",
                      backgroundColor: dotColor,
                      flexShrink: 0,
                    }}
                  />
                )}
                {label}
                {opt === value && (
                  <span style={{ marginLeft: "auto", fontSize: "0.75rem", color: "var(--ifm-color-primary)" }}>
                    ✓
                  </span>
                )}
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}

function Card({
  t,
  onClick,
}: {
  t: TemplateEntry;
  onClick: () => void;
}) {
  const m = t.meta;
  const fuel = m.engine?.fuel;
  const years =
    m.years ? `${m.years[0]}–${m.years[1]}` : "";
  const engine =
    m.engine?.displacement_cc
      ? `${m.engine.displacement_cc}cc`
      : "";

  return (
    <div
      onClick={onClick}
      className="template-bg"
      style={STYLES.card}
      onMouseEnter={(e) => {
        e.currentTarget.style.borderColor = "var(--ifm-color-primary)";
        e.currentTarget.style.transform = "translateY(-2px)";
      }}
      onMouseLeave={(e) => {
        e.currentTarget.style.borderColor = "var(--ifm-color-emphasis-300)";
        e.currentTarget.style.transform = "none";
      }}
    >
      <div style={STYLES.cardHeader}>
        <h3 style={STYLES.cardTitle}>
          {m.make} {m.model}{m.generation ? ` ${m.generation}` : ""}
        </h3>
        {fuel && (
          <span
            style={{
              ...STYLES.badge,
              backgroundColor: FUEL_COLORS[fuel] || "#666",
            }}
          >
            {FUEL_LABELS[fuel] || fuel}
          </span>
        )}
      </div>
      <div style={STYLES.cardBody}>
        {[years, engine, m.author ? `by ${m.author}` : ""]
          .filter(Boolean)
          .join(" · ")}
      </div>
      <div style={STYLES.cardFooter}>
        <span style={STYLES.count}>{t.item_count} maintenance items</span>
        <span>v{m.version}</span>
      </div>
    </div>
  );
}

export default function TemplatesPage() {
  const [data, setData] = useState<IndexData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const [selectedMake, setSelectedMake] = useState("");
  const [selectedModel, setSelectedModel] = useState("");
  const [selectedGeneration, setSelectedGeneration] = useState("");
  const [selectedFuel, setSelectedFuel] = useState("");

  const [modalTemplate, setModalTemplate] = useState<TemplateEntry | null>(
    null
  );

  useEffect(() => {
    fetch(INDEX_URL, { cache: "no-store" })
      .then((r) => {
        if (!r.ok) throw new Error(`HTTP ${r.status}`);
        return r.json();
      })
      .then((d: IndexData) => {
        setData(d);
        setLoading(false);
      })
      .catch((e) => {
        setError(e.message);
        setLoading(false);
      });
  }, []);

  useEffect(() => {
    const handler = (e: KeyboardEvent) => {
      if (e.key === "Escape") setModalTemplate(null);
    };
    document.addEventListener("keydown", handler);
    return () => document.removeEventListener("keydown", handler);
  }, []);

  const visible = useMemo(() => {
    if (!data) return [];
    let list = data.templates;

    if (selectedMake === "_base") {
      list = list.filter((t) => t.meta.make === "_base");
    } else if (selectedMake) {
      list = list.filter((t) => t.meta.make === selectedMake);
    } else {
      list = list.filter((t) => t.meta.make !== "_base");
    }
    if (selectedModel) {
      list = list.filter((t) => t.meta.model === selectedModel);
    }
    if (selectedGeneration) {
      list = list.filter(
        (t) => t.meta.generation === selectedGeneration
      );
    }
    if (selectedFuel) {
      list = list.filter(
        (t) => t.meta.engine?.fuel === selectedFuel
      );
    }

    return list;
  }, [data, selectedMake, selectedModel, selectedGeneration, selectedFuel]);

  const makes = useMemo(
    () =>
      data
        ? [...new Set(data.templates.map((t) => t.meta.make))]
            .filter(Boolean)
            .sort()
        : [],
    [data]
  );

  const models = useMemo(
    () =>
      data
        ? [
            ...new Set(
              data.templates
                .filter((t) => !selectedMake || t.meta.make === selectedMake)
                .map((t) => t.meta.model)
            ),
          ].filter(Boolean).sort()
        : [],
    [data, selectedMake]
  );

  const generations = useMemo(
    () =>
      data
        ? [
            ...new Set(
              data.templates
                .filter(
                  (t) =>
                    (!selectedMake || t.meta.make === selectedMake) &&
                    (!selectedModel || t.meta.model === selectedModel)
                )
                .map((t) => t.meta.generation)
            ),
          ].filter(Boolean).sort()
        : [],
    [data, selectedMake, selectedModel]
  );

  const allFuels = useMemo(
    () => Object.keys(FUEL_LABELS).sort(),
    []
  );

  function resetFilters() {
    setSelectedMake("");
    setSelectedModel("");
    setSelectedGeneration("");
    setSelectedFuel("");
  }

  const hasFilters =
    selectedMake ||
    selectedModel ||
    selectedGeneration ||
    selectedFuel;

  const makeOptions = useMemo(
    () => makes,
    [makes]
  );

  return (
    <Layout title="Templates" description="Browse vehicle maintenance templates">
      <div style={STYLES.container}>
        <h1 style={STYLES.title}>Maintenance Templates</h1>
        <p style={STYLES.subtitle}>
          Browse community-contributed maintenance schedules by make, model, and
          engine type.{" "}
          <Link to="https://github.com/abrahdev/karter/tree/main/templates">
            Contribute yours
          </Link>
          .
        </p>

        {loading && (
          <div style={STYLES.loading}>
            <p>Loading templates…</p>
          </div>
        )}

        {error && (
          <div style={STYLES.loading}>
            <p style={{ color: "var(--ifm-color-danger)" }}>
              Error loading templates: {error}
            </p>
            <p>
              Make sure{" "}
              <code>templates/index.json</code> exists in the repository.
            </p>
          </div>
        )}

        {data && data.templates.length === 0 && (
          <div style={STYLES.loading}>
            <p>No templates found.</p>
          </div>
        )}

        {data && data.templates.length > 0 && (
          <>
            <div className="template-bg" style={STYLES.filters}>
              <div style={STYLES.filterGroup}>
                <span style={STYLES.label}>Make</span>
                <SelectDropdown
                  value={selectedMake}
                  options={makeOptions}
                  onChange={(v) => {
                    setSelectedMake(v);
                    setSelectedModel("");
                    setSelectedGeneration("");
                  }}
                  placeholder="All makes"
                />
              </div>

              <div style={STYLES.filterGroup}>
                <span style={STYLES.label}>Model</span>
                <SelectDropdown
                  value={selectedModel}
                  options={models}
                  onChange={(v) => {
                    setSelectedModel(v);
                    setSelectedGeneration("");
                  }}
                  placeholder="All models"
                  disabled={!selectedMake}
                />
              </div>

              <div style={STYLES.filterGroup}>
                <span style={STYLES.label}>Generation</span>
                <SelectDropdown
                  value={selectedGeneration}
                  options={generations}
                  onChange={setSelectedGeneration}
                  placeholder="All generations"
                  disabled={!selectedModel}
                />
              </div>

              <div style={STYLES.filterGroup}>
                <span style={STYLES.label}>Fuel</span>
                <SelectDropdown
                  value={selectedFuel}
                  options={allFuels}
                  onChange={setSelectedFuel}
                  placeholder="All fuels"
                  getDotColor={(f) => FUEL_COLORS[f]}
                  getLabel={(f) => FUEL_LABELS[f] || f}
                />
              </div>

              {hasFilters && (
                <button className="template-bg" style={STYLES.reset} onClick={resetFilters}>
                  Clear filters
                </button>
              )}
            </div>

            <p style={STYLES.count}>
              {visible.length} template{visible.length !== 1 ? "s" : ""} found
            </p>

            {visible.map((t) => (
              <Card
                key={t.id}
                t={t}
                onClick={() => setModalTemplate(t)}
              />
            ))}
          </>
        )}

        {modalTemplate && (
          <Modal t={modalTemplate} onClose={() => setModalTemplate(null)} />
        )}
      </div>
    </Layout>
  );
}
