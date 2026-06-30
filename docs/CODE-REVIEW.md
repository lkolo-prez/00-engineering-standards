# Code Review

Code review at aircloud protects quality, spreads knowledge, and is a primary security control.
This page sets expectations for authors and reviewers.

> Org `aircloud` is an example placeholder.

## Principles

- **Review is mandatory.** Every change to a protected branch needs **2 approvals**, including
  required **CODEOWNERS** (enforced by the Ruleset, see
  [`BRANCH-PROTECTION.md`](./BRANCH-PROTECTION.md)).
- **Small PRs get better reviews.** Target < 400 lines. Split large work.
- **Be kind, be clear.** Critique code, not people. Assume good intent.
- **The author is responsible** for the change — including AI-generated lines.

## Author checklist (before requesting review)

- [ ] PR is small and focused; title uses Conventional Commits.
- [ ] CI is green (lint, format-check, typecheck, test, coverage, build, security, SAST,
      dependency-review).
- [ ] Tests added/updated; coverage meets the gate.
- [ ] Docs/runbooks/ADRs updated if behavior or architecture changed.
- [ ] No secrets, no debug code, no commented-out blocks.
- [ ] Self-reviewed the diff; left context comments where helpful.
- [ ] PR description explains **what** and **why**, and how it was tested.
- [ ] For AI-assisted changes: confirmed the
      [AI-assisted checklist](./AI-ASSISTANTS.md#review-checklist-for-ai-assisted-prs).

## Reviewer checklist

**Correctness**

- [ ] Does it do what the PR says? Edge cases and error paths handled?
- [ ] Tests actually exercise the change and would catch a regression.

**Security** (see [`SECURITY-BASELINE.md`](./SECURITY-BASELINE.md))

- [ ] Input validated; output encoded; no injection (SQL/command/template).
- [ ] AuthZ checks present and least-privilege; no secrets in code or logs.
- [ ] New dependencies justified and passed dependency-review.
- [ ] No unpinned GitHub Actions; workflow `permissions` are least-privilege.

**Design & maintainability**

- [ ] Fits existing patterns; not over-engineered, not under-engineered.
- [ ] Names are clear; complexity is justified; no obvious duplication.
- [ ] Observability: relevant logs/metrics/traces added for new behavior.

**Operability**

- [ ] Backward compatible or migration handled; feature-flagged if risky.
- [ ] Rollback path exists; no irreversible data changes without a plan.

## Comment conventions

Prefix comments with intent so authors can prioritize:

| Prefix | Meaning | Blocking? |
| --- | --- | --- |
| `blocking:` | Must change before merge | Yes |
| `question:` | I need to understand this | Maybe |
| `suggestion:` | Optional improvement | No |
| `nit:` | Trivial/style preference | No |
| `praise:` | Call out something good | No |

Use GitHub **suggestions** for small concrete fixes. Resolve threads only when addressed
(conversation resolution is required to merge).

## SLAs

| Action | Target |
| --- | --- |
| First review response | within **1 business day** (sooner for SEV-driven fixes) |
| Re-review after author updates | within **half a business day** |
| Author addresses comments | promptly; stale PRs (> 5 days idle) are pinged or closed |

## Approvals & merging

- 2 approvals incl. CODEOWNERS; all conversations resolved; CI green; branch up to date.
- **Squash-merge** by default for a linear history; the squash title is a Conventional Commit.
- The **author merges** once approved (or auto-merge once checks pass). Reviewers do not merge
  someone else's PR without asking.
- Self-approval is impossible; AI assistants cannot approve.

## Pairing & async

Pair programming or a synchronous walkthrough counts toward review for complex changes, but the
**approval still happens in GitHub** for the audit trail.
