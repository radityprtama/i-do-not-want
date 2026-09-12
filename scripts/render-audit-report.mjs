#!/usr/bin/env node

import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const repositoryRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const inputPath = path.join(repositoryRoot, "examples/audit-report.v1.json");
const outputPath = path.join(repositoryRoot, "examples/example-report.generated.md");
const report = JSON.parse(fs.readFileSync(inputPath, "utf8"));

const lines = [
  "# I DO NOT WANT — Generated Example Report",
  "",
  "<!-- Generated from examples/audit-report.v1.json. Do not edit by hand. -->",
  "",
  `Target: ${report.target.paths.join(", ")}`,
  `Evidence mode: ${report.evidenceMode}`,
  ""
];

for (const finding of report.findings) {
  const severity = finding.severity ? `${finding.severity} — ` : "";
  lines.push(`## ${severity}\`${finding.checkId}\` — ${finding.status}`, "");
  lines.push(`**Rationale:** ${finding.rationale}`, "");
  if (finding.evidence?.length) {
    lines.push("**Evidence:**", "");
    for (const evidence of finding.evidence) {
      const summary = evidence.summary ? ` — ${evidence.summary}` : "";
      lines.push(`- ${evidence.location}${summary}`);
    }
    lines.push("");
  }
  if (finding.remediation) lines.push(`**Remediation:** ${finding.remediation}`, "");
  lines.push(`**Verification:** ${finding.verification.method}`, "");
  if (finding.limitations.length) {
    lines.push("**Limitations:**", "", ...finding.limitations.map((item) => `- ${item}`), "");
  }
}

lines.push("## Ship decision", "", `**${report.shipDecision.replaceAll("_", " ")}**`, "");
const rendered = `${lines.join("\n")}\n`;

if (process.argv.includes("--check")) {
  if (!fs.existsSync(outputPath) || fs.readFileSync(outputPath, "utf8") !== rendered) {
    console.error("examples/example-report.generated.md is out of date; run npm run render:report");
    process.exit(1);
  }
  console.log("Generated human report matches its machine-readable source.");
} else {
  fs.writeFileSync(outputPath, rendered);
  console.log("Wrote examples/example-report.generated.md");
}
