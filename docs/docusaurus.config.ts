import { themes as prismThemes } from "prism-react-renderer";
import type { Config } from "@docusaurus/types";
import type * as Preset from "@docusaurus/preset-classic";
import fs from "fs";
import path from "path";

const appVersion = fs
  .readFileSync(path.join(__dirname, "..", "VERSION"), "utf-8")
  .trim();

const versionsJson = JSON.parse(
  fs.readFileSync(path.join(__dirname, "versions.json"), "utf-8")
);
const lastVersion = versionsJson[0];

const config: Config = {
  title: `Karter v${appVersion}`,
  tagline: "Open Source Vehicle Maintenance & Social Impact",
  favicon: "img/karter-favicon.svg",

  url: "https://karter.abrah.dev",
  baseUrl: "/",
  organizationName: "abrahdev",
  projectName: "karter",

  customFields: {
    appVersion,
  },

  future: {
    v4: true,
  },

  onBrokenLinks: "warn",

  i18n: {
    defaultLocale: "en",
    locales: ["en"],
  },

  markdown: {
    mermaid: true,
    hooks: {
      onBrokenMarkdownLinks: "warn",
    },
  },

  themes: ["@docusaurus/theme-mermaid"],

  presets: [
    [
      "classic",
      {
        docs: {
          sidebarPath: "./sidebars.ts",
          editUrl: "https://github.com/abrahdev/karter/edit/main/docs/",
          routeBasePath: '/',
          lastVersion,
          versions: {
            current: {
              label: `Next (${appVersion})`,
            },
          },
        },
        blog: false,
        theme: {
          customCss: "./src/css/custom.css",
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    image: "img/karter-social-card.jpg",
    mermaid: {
      theme: { light: 'neutral', dark: 'forest' },
    },
    navbar: {
      title: `Karter v${appVersion}`,
      logo: {
        alt: "Karter Logo",
        src: "img/karter-logo.svg",
        href: "/",
      },
      items: [
        {
          type: "docSidebar",
          sidebarId: "tutorialSidebar",
          position: "right",
          label: "Docs",
        },
        { type: "docsVersionDropdown", position: "right" },
        {
          href: "https://github.com/abrahdev/karter",
          label: "GitHub",
          position: "right",
        },
      ],
    },
    footer: {
      style: "dark",
      links: [
        {
          title: "Overview",
          items: [
            { label: "Manifest", to: "/" }, 
            { label: "Development", to: "/category/developer" },
            { label: "Contributing", to: "/contributing" },
          ],
        },
        {
          title: "Documentation",
          items: [{ label: "Roadmap", to: "/roadmap" }],
        },
        {
          title: "Community & Support",
          items: [
            {
              label: "GitHub Sponsors",
              href: "https://github.com/sponsors/abrahdev",
            },
          ],
        },
      ],
      copyright: `Karter v${appVersion} uses GNU AGPL v3 License. Built with Docusaurus.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,

  plugins: [
    [
      require.resolve("@easyops-cn/docusaurus-search-local"),
      {
        hashed: true,
        language: ["en"],
        highlightSearchTermsOnTargetPage: true,
        indexBlog: false,
        explicitSearchResultPath: true,
        docsRouteBasePath: "/", 
      },
    ],
  ],
};

export default config;