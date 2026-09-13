# Changelog

All notable changes will be documented here.

## 0.2.0 — 2026-09-13

### Added
- deterministic Ruby validation for skill structure, frontmatter, local Markdown
  references and duplicate canonical check IDs;
- least-privilege GitHub Actions `validate` workflow;
- deliberately broken, non-deployable Next.js audit fixture with validated expected
  findings;
- JSON Schema Draft 2020-12 audit report contract and generated human example;
- reproducible Codex behavioral compatibility prompts and bounded evidence report;
- evidence-backed launch copy, terminal asset and seven-day measurement template.

### Changed
- skill reference paths now use normal Markdown links for deterministic validation;
- README documents v0.2 features, current repository structure and complete validation;
- the example domain summary uses the established `NOT_VERIFIED` vocabulary.

### Security
- Ajv is pinned to 8.20.0, avoiding `GHSA-2g4f-4pwh-qvx6` in the originally
  considered 8.17.1 release;
- GitHub Actions dependencies are pinned to immutable commit SHAs.

### Limitations
- Codex behavior was observed against the globally installed skill snapshot; a fresh
  installation of the exact v0.2.0 entrypoints was not verified.
- Claude Code and OpenCode behavioral verification remains follow-up work.

## 0.1.0 — 2026-09-09

### Added
- root `i-do-not-want` pre-ship orchestrator;
- security audit skill;
- legal/trust audit skill;
- privacy engineering audit skill;
- accessibility audit skill;
- production/reliability audit skill;
- evidence/status/severity contract;
- stable check-ID registry;
- authoring and architecture documentation;
- example consolidated ship report.
