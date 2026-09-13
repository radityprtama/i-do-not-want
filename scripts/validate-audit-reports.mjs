#!/usr/bin/env node

import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import Ajv2020 from "ajv/dist/2020.js";

const repositoryRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const readJson = (relativePath) => JSON.parse(fs.readFileSync(path.join(repositoryRoot, relativePath), "utf8"));
const schema = readJson("schemas/audit-report-v1.schema.json");
const ajv = new Ajv2020({ strict: true, allErrors: true });
const validate = ajv.compile(schema);
const failures = [];

const validExample = "examples/audit-report.v1.json";
if (!validate(readJson(validExample))) {
  failures.push(`${validExample}: expected valid, got ${ajv.errorsText(validate.errors, { separator: "\n" })}`);
}

const invalidExamples = [
  {
    file: "test/fixtures/audit-reports/pass-without-evidence.json",
    expected: (errors) => errors.some((error) =>
      error.instancePath === "/findings/0" &&
      error.keyword === "required" &&
      error.params.missingProperty === "evidence"
    ),
    reason: "PASS must require evidence"
  },
  {
    file: "test/fixtures/audit-reports/pass-with-empty-evidence.json",
    expected: (errors) => errors.some((error) =>
      error.instancePath === "/findings/0/evidence" && error.keyword === "minItems"
    ),
    reason: "PASS evidence must not be empty"
  },
  {
    file: "test/fixtures/audit-reports/invalid-status.json",
    expected: (errors) => errors.some((error) =>
      error.instancePath === "/findings/0/status" && error.keyword === "enum"
    ),
    reason: "status vocabulary must be constrained"
  },
  {
    file: "test/fixtures/audit-reports/invalid-severity.json",
    expected: (errors) => errors.some((error) =>
      error.instancePath === "/findings/0/severity" && error.keyword === "enum"
    ),
    reason: "severity vocabulary must be constrained"
  }
];

for (const invalid of invalidExamples) {
  const accepted = validate(readJson(invalid.file));
  const errors = validate.errors ?? [];
  if (accepted) {
    failures.push(`${invalid.file}: unexpectedly valid (${invalid.reason})`);
  } else if (!invalid.expected(errors)) {
    failures.push(`${invalid.file}: failed, but not for expected reason (${invalid.reason}): ${ajv.errorsText(errors)}`);
  }
}

if (failures.length > 0) {
  console.error(failures.join("\n"));
  process.exit(1);
}

console.log(`Validated ${validExample} and ${invalidExamples.length} intentional failures with Ajv ${Ajv2020.version ?? "8.20.0"}.`);
