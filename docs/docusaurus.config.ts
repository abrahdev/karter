import { themes as prismThemes } from "prism-react-renderer";
import type { Config } from "@docusaurus/types";
import type * as Preset from "@docusaurus/preset-classic";

const config: Config = {
  title: "Karter",
  tagline: "Open Source Vehicle Maintenance & Social Impact",
  favicon: "img/favicon.ico",

  url: "https://abrahdev.github.io",
  baseUrl: "/karter/",
  organizationName: "abrahdev",
  projectName: "karter",

  future: {
    v4: true,
  },

  onBrokenLinks: "warn",
  onBrokenMarkdownLinks: "warn",

  i18n: {
    defaultLocale: "en",
    locales: ["en"],
  },

  presets: [
    [
      "classic",
      {
        docs: {
          sidebarPath: "./sidebars.ts",
          editUrl: "https://github.com/abrahdev/karter/tree/main/docs/",
          routeBasePath: '/', 
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
    navbar: {
      title: "Karter Docs",
      logo: {
        alt: "Karter Logo",
        src: "/assets/branding/karter-logo-inlne.svg",
        href: "/",
      },
      items: [
        {
          type: "docsVersionDropdown",
          position: "right",
        },
        {
          type: "localeDropdown",
          position: "right",
        },
        {
          type: "docSidebar",
          sidebarId: "tutorialSidebar",
          position: "right",
          label: "Docs",
        },
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
      copyright: `Karter uses GNU AGPL v3 License. Built with Docusaurus.`,
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