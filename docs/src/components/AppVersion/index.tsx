import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import React from "react";

interface Props {
  prefix?: string;
}

export default function AppVersion({ prefix = "v" }: Props): JSX.Element {
  const { siteConfig } = useDocusaurusContext();
  const version = (siteConfig.customFields as Record<string, string>).appVersion;
  return <code>{prefix}{version}</code>;
}
