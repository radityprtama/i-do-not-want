# Codex Behavioral Compatibility — 2026-09-13

## Result

Codex behavioral execution is **OBSERVED** for the installed skill snapshot on
`codex-cli 0.151.0`.

All six read-only, ephemeral audit prompts completed successfully. Tool events show
that Codex loaded each requested `SKILL.md`, subsequently loaded applicable reference
files, inspected the synthetic fixture, used the repository's report vocabulary, and
left the repository unchanged.

The installed files under `/home/raditya/.agents/skills/` were compared with this
branch. Reference files matched. The six `SKILL.md` entrypoints differed only because
this branch converted backticked reference paths into normal Markdown links in
WIP-190. This run therefore establishes behavior for the semantically equivalent
installed snapshot, but a fresh installation of the exact branch snapshot remains
**NOT_VERIFIED**.

## Environment

| Field | Observed value |
|---|---|
| Date (UTC) | 2026-09-13 |
| Codex | `codex-cli 0.151.0` |
| System | `Linux 6.1.0-45-amd64 x86_64 GNU/Linux` |
| Repository commit tested | `e0d2de467a80347f271205964ec647507d24dfe2` |
| Installed skills | `/home/raditya/.agents/skills/i-do-not-want*` |
| Target | `fixtures/broken-nextjs` |
| Sandbox | `read-only` |
| Session persistence | `--ephemeral` |
| User configuration | Enabled |
| Raw output location | Temporary directory outside the repository; not committed |

A preliminary smoke test returned exactly `CODEX_READY` with exit code 0. This
replaced the prior 2026-09-12 result, where configuration and credential errors had
prevented model execution.

## Reproducible invocation

Each file under `docs/compatibility/prompts/` was invoked separately:

```bash
codex exec \
  --sandbox read-only \
  --ephemeral \
  --json \
  --color never \
  -C fixtures/broken-nextjs \
  - < docs/compatibility/prompts/ROOT_OR_DOMAIN-audit.md
```

`ROOT_OR_DOMAIN` was replaced with `root`, `security`, `legal-trust`, `privacy`,
`accessibility`, and `production`. Raw JSONL and stderr were written under `/tmp` and
were not added to the repository.

## Behavioral matrix

| Capability | Result | Evidence / limitation |
|---|---|---|
| Root skill explicit invocation | OBSERVED | Exit 0; root skill and router/report references were read; a bounded ship report was produced. |
| Security skill explicit invocation | OBSERVED | Exit 0; security skill and applicable references were read; source-backed findings were produced. |
| Legal/trust skill explicit invocation | OBSERVED | Exit 0; legal/trust skill and references were read; legal uncertainty remained bounded. |
| Privacy skill explicit invocation | OBSERVED | Exit 0; privacy skill and references were read; source-backed and NOT_VERIFIED results were separated. |
| Accessibility skill explicit invocation | OBSERVED | Exit 0; accessibility skill and references were read; runtime and AT behavior remained NOT_VERIFIED. |
| Production skill explicit invocation | OBSERVED | Exit 0; production skill and references were read; no runtime or recovery evidence was invented. |
| Root orchestrator routing | OBSERVED | Root events show the root skill, three router/report references, all five domain skills, and applicable domain references loaded in sequence. |
| Progressive reference loading | OBSERVED | In every run, command events show the selected `SKILL.md` read before `references/*.md`. |
| Report vocabulary consistency | OBSERVED | Bounded outputs used only PASS/WARN/FAIL/BLOCKED/NOT_APPLICABLE/NOT_VERIFIED tokens; no PASS was claimed. |
| Audit-only non-mutation | OBSERVED | Every status/diff check was clean and every deterministic source hash matched. |
| Exact current-branch installation | NOT_VERIFIED | Codex used the installed snapshot; branch entrypoints differ only in Markdown-link formatting, but were not reinstalled for this run. |

## Progressive-loading evidence

The JSONL event stream exposes completed `command_execution` items. Bounded event
inspection established these orderings:

- root: root `SKILL.md` → product-profile/audit-router/final-report references → five
  domain `SKILL.md` files → applicable domain references;
- security: security `SKILL.md` → fixture inventory → six applicable references;
- legal/trust: legal `SKILL.md` → product inventory → seven further applicable
  references;
- privacy: privacy `SKILL.md` → fixture inventory → privacy references;
- accessibility: accessibility `SKILL.md` → three initial references → three remaining
  applicable references;
- production: production `SKILL.md` → fixture inventory → five references.

This is direct tool-event evidence rather than a model claim. Full event streams are
not committed because bounded commands, ordering and paths are sufficient for this
compatibility result.

## Report evidence

The root run produced a `DO NOT SHIP` decision from static fixture evidence. It found
the seeded authorization blocker and high-impact security, legal/trust, privacy,
accessibility and production defects. It separately reported controls lacking runtime,
jurisdiction, deployment, assistive-technology or provider evidence as
`NOT_VERIFIED` or `NOT_APPLICABLE`.

Individual domain runs completed and cited fixture paths. No output contained a PASS
claim, so this run does not test a positive PASS-evidence example; it does show that
missing evidence was retained as `NOT_VERIFIED` rather than converted to PASS.

## Non-mutation evidence

Before and after every invocation:

```bash
git status --porcelain
git diff --exit-code
```

All status outputs were empty and all diff commands returned 0.

The deterministic hash covered sorted relative paths and file bytes under exactly:

```text
skills/
fixtures/broken-nextjs/
```

It excluded `.git`, `node_modules`, `.cache`, `cache`, `tmp`, `*.log`, timestamps and
filesystem metadata. Every pre/post hash was:

```text
df49e6cb2d8f9c76cd6a706c8f926f026f47371ca508fc1e9c3a9ed68614b197
```

## Known limitations

- Codex exercised the globally installed snapshot, not a fresh install of the exact
  branch entrypoints. Their observed differences are limited to Markdown link markup.
- The audit was static; no fixture route or external service was executed.
- No output made a PASS claim, so PASS evidence behavior was not behaviorally tested.
- Claude Code and OpenCode behavioral verification remain in related follow-up WIP-211.
- Full transcripts are intentionally not committed; reproducible prompts, commands,
  bounded event evidence and final-result summaries are retained.
