import React, { useEffect, useState, useMemo, useCallback } from "react";
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
    background: "var(--ifm-card-background-color)",
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
  fuelCheckboxes: {
    display: "flex",
    flexWrap: "wrap" as const,
    gap: "0.5rem",
    marginTop: "0.25rem",
  },
  fuelCheck: {
    display: "flex",
    alignItems: "center",
    gap: "0.3rem",
    fontSize: "0.85rem",
    cursor: "pointer",
  },
  card: {
    border: "1px solid var(--ifm-color-emphasis-300)",
    borderRadius: 10,
    padding: "1.25rem",
    marginBottom: "0.75rem",
    background: "var(--ifm-card-background-color)",
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

  const sourceUrl = `https://github.com/abrahdev/karter/blob/main/templates/${t.path}`;

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
  const [fuelFilters, setFuelFilters] = useState<Set<string>>(new Set());

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

    if (selectedMake) {
      list = list.filter((t) => t.meta.make === selectedMake);
    }
    if (selectedModel) {
      list = list.filter((t) => t.meta.model === selectedModel);
    }
    if (selectedGeneration) {
      list = list.filter(
        (t) => t.meta.generation === selectedGeneration
      );
    }
    if (fuelFilters.size > 0) {
      list = list.filter(
        (t) => t.meta.engine?.fuel && fuelFilters.has(t.meta.engine.fuel)
      );
    }

    return list;
  }, [data, selectedMake, selectedModel, selectedGeneration, fuelFilters]);

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

  function toggleFuel(fuel: string) {
    setFuelFilters((prev) => {
      const next = new Set(prev);
      if (next.has(fuel)) next.delete(fuel);
      else next.add(fuel);
      return next;
    });
  }

  function resetFilters() {
    setSelectedMake("");
    setSelectedModel("");
    setSelectedGeneration("");
    setFuelFilters(new Set());
  }

  const hasFilters =
    selectedMake ||
    selectedModel ||
    selectedGeneration ||
    fuelFilters.size > 0;

  const makeOptions = useMemo(
    () => makes.filter((m) => m !== "_base"),
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
            <div style={STYLES.filters}>
              <div style={STYLES.filterGroup}>
                <span style={STYLES.label}>Make</span>
                <select
                  style={STYLES.select}
                  value={selectedMake}
                  onChange={(e) => {
                    setSelectedMake(e.target.value);
                    setSelectedModel("");
                    setSelectedGeneration("");
                  }}
                >
                  <option value="">All makes</option>
                  {makeOptions.map((m) => (
                    <option key={m} value={m}>
                      {m}
                    </option>
                  ))}
                </select>
              </div>

              <div style={STYLES.filterGroup}>
                <span style={STYLES.label}>Model</span>
                <select
                  style={STYLES.select}
                  value={selectedModel}
                  onChange={(e) => {
                    setSelectedModel(e.target.value);
                    setSelectedGeneration("");
                  }}
                  disabled={!selectedMake}
                >
                  <option value="">All models</option>
                  {models.map((m) => (
                    <option key={m} value={m}>
                      {m}
                    </option>
                  ))}
                </select>
              </div>

              <div style={STYLES.filterGroup}>
                <span style={STYLES.label}>Generation</span>
                <select
                  style={STYLES.select}
                  value={selectedGeneration}
                  onChange={(e) => setSelectedGeneration(e.target.value)}
                  disabled={!selectedModel}
                >
                  <option value="">All generations</option>
                  {generations.map((g) => (
                    <option key={g} value={g}>
                      {g}
                    </option>
                  ))}
                </select>
              </div>

              <div style={STYLES.filterGroup}>
                <span style={STYLES.label}>Fuel</span>
                <div style={STYLES.fuelCheckboxes}>
                  {allFuels.map((f) => (
                    <label key={f} style={STYLES.fuelCheck}>
                      <input
                        type="checkbox"
                        checked={fuelFilters.has(f)}
                        onChange={() => toggleFuel(f)}
                      />
                      <span
                        style={{
                          display: "inline-block",
                          width: 10,
                          height: 10,
                          borderRadius: "50%",
                          backgroundColor: FUEL_COLORS[f] || "#666",
                        }}
                      />
                      {FUEL_LABELS[f] || f}
                    </label>
                  ))}
                </div>
              </div>

              {hasFilters && (
                <button style={STYLES.reset} onClick={resetFilters}>
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
