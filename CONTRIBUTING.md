# Contributing

Thanks for improving the aircloud engineering handbook. This repo is **documentation + shared
config**, so contributions are mostly Markdown edits and CI/config tweaks.

> `aircloud` is an example placeholder org name.

## Ground rules

- Be respectful — see [`CODE_OF_CONDUCT.md`](./CODE_OF_CONDUCT.md).
- Follow [trunk-based development](./docs/BRANCHING-AND-RELEASE.md): branch off `main`, keep it
  short-lived, squash-merge.
- Use [Conventional Commits](https://www.conventionalcommits.org) and **sign your commits**
  (verified). See [Branch Protection → signed commits](./docs/BRANCH-PROTECTION.md#signed-commits).

## Workflow

1. **Open or pick an issue.** Use the issue templates. For a new mandatory control or a new
   golden path, open a Feature request (RFC) first.
2. **Branch:** `git switch -c docs/<topic>` (or `ci/`, `chore/`).
3. **Edit** the relevant file(s). Keep changes focused and cross-link related docs.
4. **Lint locally:**
   ```bash
   make lint        # markdownlint + vale
   make linkcheck   # lychee link check
   make test        # both of the above
   ```
5. **Commit** (signed, Conventional):
   `git commit -S -m "docs: clarify SLSA provenance requirement"`.
6. **Open a PR** filling in the template. CI runs `docs-lint` and `scorecard` (required checks).
7. **Reviews:** 2 approvals including a CODEOWNER. Baseline changes
   (`docs/SECURITY-BASELINE.md`) require `@aircloud/security`.
8. **Merge** (squash). `release-please` opens/updates the Release PR; a maintainer merges it to
   tag a release.

## Style

- Write in clear, plain English. Prefer short sentences and tables over walls of text.
- Use relative links between docs (e.g. `./docs/CODE-REVIEW.md`).
- Keep Markdown tables valid and wrap prose at a reasonable width.
- Mermaid diagrams are encouraged; keep them simple and renderable on GitHub.
- Keep org placeholders (`aircloud`, `ghcr.io/aircloud`, Azure prefix `aircloud`) consistent and
  noted as examples.

## What needs extra care

- **Security baseline** changes affect every repo — be precise, map to frameworks, and explain
  the enforcement/rollout plan.
- **AI-assistant guidance** — keep `docs/AI-ASSISTANTS.md` and the in-repo `CLAUDE.md` /
  `AGENTS.md` / Copilot / Cursor files mutually consistent.

## Reporting security issues

Do **not** open a public issue for vulnerabilities. Follow [`SECURITY.md`](./SECURITY.md).

## Dependency bots

This repo ships **both** a Dependabot config (`.github/dependabot.yml`) and a Renovate config
(`.github/renovate.json`) as reference implementations of the baseline. **Enable only one** in a
real repo to avoid duplicate PRs — most teams pick Renovate for its grouping and digest pinning.
Whichever you keep, it must SHA-pin GitHub Actions with a version comment.

## License

By contributing, you agree your contributions are licensed under [Apache-2.0](./LICENSE).
