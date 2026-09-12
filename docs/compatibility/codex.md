# Codex Behavioral Compatibility — 2026-09-12

## Result

Codex behavioral compatibility is **NOT_VERIFIED** in this environment.

The CLI was available and all six audit commands were attempted, but no model turn
started because the configured API credential was rejected with HTTP 401
`invalid_api_key`. This report does not treat installation or command availability as
behavioral compatibility.

## Environment

| Field | Observed value |
|---|---|
| Date (UTC) | 2026-09-12 |
| Codex | `codex-cli 0.151.0` |
| System | `Linux 6.1.0-45-amd64 x86_64 GNU/Linux` |
| Repository commit tested | `348bf58cd74fa4df506a321d6d5f6a33a8048f1d` |
| Target | `fixtures/broken-nextjs` |
| Sandbox | `read-only` |
| Session persistence | `--ephemeral` |
| Raw output location | Temporary directory outside the repository; not committed |

The first attempts used normal user configuration and stopped before execution because
`config.toml` contained an incompatible `tui.model_availability_nux` value. The runs
were repeated with `--ignore-user-config`; authentication is retained by that option,
but the API rejected the available credential. No credential value is recorded here.

## Reproducible invocation

Each file under `docs/compatibility/prompts/` was invoked separately:

```bash
codex exec \
  --ignore-user-config \
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
| Root skill explicit invocation | NOT_VERIFIED | Command attempted; API returned HTTP 401 before a model turn. |
| Security skill explicit invocation | NOT_VERIFIED | Command attempted; API returned HTTP 401 before a model turn. |
| Legal/trust skill explicit invocation | NOT_VERIFIED | Command attempted; API returned HTTP 401 before a model turn. |
| Privacy skill explicit invocation | NOT_VERIFIED | Command attempted; API returned HTTP 401 before a model turn. |
| Accessibility skill explicit invocation | NOT_VERIFIED | Command attempted; API returned HTTP 401 before a model turn. |
| Production skill explicit invocation | NOT_VERIFIED | Command attempted; API returned HTTP 401 before a model turn. |
| Root orchestrator routing | NOT_VERIFIED | No model turn occurred. |
| Progressive reference loading | NOT_VERIFIED | JSONL contained only transport/authentication errors; no file-read event occurred. |
| Report vocabulary consistency | NOT_VERIFIED | No audit report was produced. |
| Audit-only non-mutation | OBSERVED | Git status/diff remained clean and deterministic source hashes matched before/after every attempt. |

## Non-mutation evidence

Before the attempts, the WIP-193 harness was copied to `/tmp` and stashed so the
repository itself was clean. After every invocation:

```bash
git status --porcelain
git diff --exit-code
```

`git status --porcelain` was empty and `git diff --exit-code` returned 0.

The deterministic hash covered file paths and bytes under exactly:

```text
skills/
fixtures/broken-nextjs/
```

It excluded `.git`, `node_modules`, `.cache`, `cache`, `tmp`, `*.log`, timestamps and
other filesystem metadata. The sorted relative path is included in each file's hash
input, so renames change the result.

Observed pre/post SHA-256:

```text
df49e6cb2d8f9c76cd6a706c8f926f026f47371ca508fc1e9c3a9ed68614b197
```

All six post-attempt hashes matched that value.

## Progressive-loading boundary

A model's statement that it read a reference would not be sufficient proof. An
`OBSERVED` result requires Codex tool events showing an ordered read of the selected
`SKILL.md` followed by applicable `references/*.md` files. The captured events had no
file reads because authentication failed, so this capability remains `NOT_VERIFIED`.

## Known limitations

- The available Codex API credential was invalid at execution time.
- No model turn or audit report was produced.
- Root routing, reference loading, findings and vocabulary remain unverified.
- Claude Code and OpenCode behavioral verification are outside this narrowed report.
- Full transcripts are intentionally not committed; only safe prompts, commands and
  bounded observations are retained.
