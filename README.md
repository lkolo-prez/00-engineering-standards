<p align="center">
  <a href="https://aircloud.com.pl"><img src=".github/assets/banner.png" alt="AIRCLOUD: DevOps, cloud and AI engineering" width="100%"></a>
</p>

# 00-engineering-standards

**Engineering handbook for the AIRCLOUD golden path: paved-road templates, a security baseline and an AI-assistant policy.**

[![docs-lint](https://github.com/lkolo-prez/00-engineering-standards/actions/workflows/docs-lint.yml/badge.svg)](https://github.com/lkolo-prez/00-engineering-standards/actions/workflows/docs-lint.yml)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](./LICENSE)

> **This is a template repository.** The organization name `aircloud`, the container
> registry `ghcr.io/aircloud`, and the Azure naming prefix `aircloud` are **examples**.
> Replace them with your own when you adopt these standards. Every occurrence is
> intentionally consistent so a single find-and-replace works.

---

## What's inside

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

## Usage

1. **Pick a template.** Browse [`CATALOG.md`](./CATALOG.md) and choose the template repo that
   matches your workload (backend TS/Go/Python, Next.js frontend, Terraform/Azure, Argo CD
   GitOps).
2. **Create your repo from the template.** Use _"Use this template"_ on GitHub, or
   `gh repo create <your-org>/<name> --template lkolo-prez/<template> --private`.
3. **Run the bootstrap.** Each template ships a `make setup` (or `task setup`) target that
   installs tooling, pre-commit hooks, and validates your environment.
4. **Apply branch protection.** Follow [`docs/BRANCH-PROTECTION.md`](./docs/BRANCH-PROTECTION.md)
   to apply the standard GitHub Ruleset (2 reviews, CODEOWNERS, signed commits, linear
   history, required checks).
5. **Wire AI assistants.** The templates already include `CLAUDE.md`, `AGENTS.md`,
   `.github/copilot-instructions.md`, and `.cursor/rules/` — keep them in sync with the real
   commands in your repo per [`docs/AI-ASSISTANTS.md`](./docs/AI-ASSISTANTS.md).

### Working on this repo

```bash
make setup      # markdownlint, lychee, vale + pre-commit hooks
make lint       # markdownlint + vale prose lint
make linkcheck  # lychee link check
make test       # lint + linkcheck (what CI runs)
```

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

---

## Part of the AIRCLOUD golden path

| Repository | What it is |
| --- | --- |
| **00-engineering-standards** (this repo) | Golden paths, security baseline, AI-assistant policy (handbook) |
| [template-terraform-azure](https://github.com/lkolo-prez/template-terraform-azure) | Terraform on Azure: private AKS, Key Vault, ACR, OIDC, policy-as-code |
| [template-gitops-argocd](https://github.com/lkolo-prez/template-gitops-argocd) | Argo CD, Kustomize, Argo Rollouts, Kyverno, External Secrets |
| [template-backend-python](https://github.com/lkolo-prez/template-backend-python) | FastAPI, Python 3.12, uv, ruff, pytest |
| [template-backend-go](https://github.com/lkolo-prez/template-backend-go) | Go 1.23, chi, slog, OpenTelemetry, golangci-lint |
| [template-backend-typescript](https://github.com/lkolo-prez/template-backend-typescript) | Node 22, TypeScript, Fastify 5, Zod, Vitest, pnpm |
| [template-frontend-nextjs](https://github.com/lkolo-prez/template-frontend-nextjs) | Next.js 15, React 19, Tailwind v4, Playwright, Lighthouse CI |
| [.github](https://github.com/lkolo-prez/.github) | Reusable CI/CD workflows and community-health defaults |

Terraform modules for Azure: [AIRCLOUD-PL](https://github.com/AIRCLOUD-PL).

Built and maintained by [AIRCLOUD](https://aircloud.com.pl): DevOps, cloud and AI engineering. Need help adopting the golden path? See [aircloud.com.pl/consulting](https://aircloud.com.pl/consulting).
