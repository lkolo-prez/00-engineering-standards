# Engineering Standards

> The aircloud Engineering Handbook and the source of truth for our **golden paths**, security baseline, and AI-assistant policy.

[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/aircloud/00-engineering-standards/badge)](https://securityscorecards.dev/viewer/?uri=github.com/aircloud/00-engineering-standards)
[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](./LICENSE)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://www.conventionalcommits.org)

> **This is a template repository.** The organization name `aircloud`, the container
> registry `ghcr.io/aircloud`, and the Azure naming prefix `aircloud` are **examples**.
> Replace them with your own when you adopt these standards. Every occurrence is
> intentionally consistent so a single find-and-replace works.

---

## What this repo is

This repository is **documentation + shared configuration templates**. It is **not** a
deployable service — there is no application code to run. It defines _how_ we build software
at aircloud so that every team starts from the same paved road:

- **Golden paths** — the supported, opinionated way to start a backend, frontend, IaC, or
  GitOps project. See [`docs/GOLDEN-PATHS.md`](./docs/GOLDEN-PATHS.md).
- **Security baseline** — the controls every repository MUST implement, mapped to SLSA,
  OpenSSF Scorecard, NIST SSDF, OWASP ASVS, CIS, and SOC 2. See
  [`docs/SECURITY-BASELINE.md`](./docs/SECURITY-BASELINE.md).
- **AI-assistant policy** — how we standardize Claude Code, Codex (agents.md), GitHub
  Copilot, and Cursor across the org. See [`docs/AI-ASSISTANTS.md`](./docs/AI-ASSISTANTS.md).
- **Process** — branching, releases, code review, definition of done, observability, and
  incident response.

## How to use the golden paths

1. **Pick a template.** Browse [`CATALOG.md`](./CATALOG.md) and choose the template repo that
   matches your workload (backend TS/Go/Python, Next.js frontend, Terraform/Azure, Argo CD
   GitOps).
2. **Create your repo from the template.** Use _"Use this template"_ on GitHub, or
   `gh repo create aircloud/<name> --template aircloud/<template> --private`.
3. **Run the bootstrap.** Each template ships a `make setup` (or `task setup`) target that
   installs tooling, pre-commit hooks, and validates your environment.
4. **Apply branch protection.** Follow [`docs/BRANCH-PROTECTION.md`](./docs/BRANCH-PROTECTION.md)
   to apply the standard GitHub Ruleset (2 reviews, CODEOWNERS, signed commits, linear
   history, required checks).
5. **Wire AI assistants.** The templates already include `CLAUDE.md`, `AGENTS.md`,
   `.github/copilot-instructions.md`, and `.cursor/rules/` — keep them in sync with the real
   commands in your repo per [`docs/AI-ASSISTANTS.md`](./docs/AI-ASSISTANTS.md).

## Documentation index

| Document | Purpose |
| --- | --- |
| [`docs/GOLDEN-PATHS.md`](./docs/GOLDEN-PATHS.md) | The paved road per workload type. |
| [`docs/SECURITY-BASELINE.md`](./docs/SECURITY-BASELINE.md) | Mandatory org-wide controls + control matrix. |
| [`docs/AI-ASSISTANTS.md`](./docs/AI-ASSISTANTS.md) | AI coding assistant standardization + templates. |
| [`docs/BRANCHING-AND-RELEASE.md`](./docs/BRANCHING-AND-RELEASE.md) | Trunk-based dev, Conventional Commits, release-please. |
| [`docs/BRANCH-PROTECTION.md`](./docs/BRANCH-PROTECTION.md) | GitHub Rulesets config + gh/Terraform snippets. |
| [`docs/THREAT-MODEL-TEMPLATE.md`](./docs/THREAT-MODEL-TEMPLATE.md) | STRIDE template + data classification. |
| [`docs/OBSERVABILITY.md`](./docs/OBSERVABILITY.md) | OpenTelemetry + SLOs. |
| [`docs/INCIDENT-RESPONSE.md`](./docs/INCIDENT-RESPONSE.md) | On-call runbook. |
| [`docs/CODE-REVIEW.md`](./docs/CODE-REVIEW.md) | Code review expectations. |
| [`docs/DEFINITION-OF-DONE.md`](./docs/DEFINITION-OF-DONE.md) | When work is _done_. |
| [`docs/ARCHITECTURE.md`](./docs/ARCHITECTURE.md) | How this repo is structured + a runbook. |
| [`CATALOG.md`](./CATALOG.md) | Index of all template repositories. |

## Contributing

Read [`CONTRIBUTING.md`](./CONTRIBUTING.md). In short: branch from `main`, use
[Conventional Commits](https://www.conventionalcommits.org), sign your commits, open a PR,
and let `release-please` cut the release. Changes to the security baseline require review
from `@aircloud/security`.

## License

[Apache-2.0](./LICENSE). © aircloud and contributors.
