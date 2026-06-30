# Definition of Done

A change is **done** when all of the following are true. "It works on my machine" is not done.
This checklist is the shared contract across teams; service repos may add to it but not remove.

> Org `aircloud` is an example placeholder.

## Code & tests

- [ ] Implements the agreed scope; acceptance criteria met.
- [ ] Unit + integration tests added/updated; **coverage gate** passes.
- [ ] `make lint`, `make format`, typecheck, and `make test` all pass locally and in CI.
- [ ] No new linter/SAST warnings introduced.

## Security & supply chain

- [ ] No secrets in code, history, or logs (gitleaks clean).
- [ ] New dependencies passed `dependency-review`; SBOM still generates.
- [ ] Input validated, output encoded, authZ enforced where relevant.
- [ ] GitHub Actions remain SHA-pinned; workflow permissions least-privilege.
- [ ] Threat model updated if the attack surface changed
      (see [`THREAT-MODEL-TEMPLATE.md`](./THREAT-MODEL-TEMPLATE.md)).

## Observability & operability

- [ ] Logs/metrics/traces added for new behavior (see [`OBSERVABILITY.md`](./OBSERVABILITY.md)).
- [ ] Health/readiness probes still valid; dashboards/alerts updated if needed.
- [ ] Feature-flagged if risky; rollback path is clear.

## Documentation

- [ ] README/usage docs updated if behavior changed.
- [ ] Architecture doc / ADR updated for design changes
      (see [`ARCHITECTURE.md`](./ARCHITECTURE.md)).
- [ ] Runbook updated for new operational concerns.
- [ ] AI config (`CLAUDE.md`/`AGENTS.md`/Copilot/Cursor) still matches the real commands.

## Process

- [ ] Conventional Commit messages; commits **signed (verified)**.
- [ ] PR reviewed: **2 approvals** incl. CODEOWNERS; conversations resolved.
- [ ] CI green: lint, format-check, typecheck, test, coverage, build, security, SAST,
      dependency-review.
- [ ] Merged to `main` via squash; release handled by `release-please`.

## Delivery (for services)

- [ ] Deployed to **dev**, smoke-tested; promotes to **staging** automatically.
- [ ] Promotion to **prod** approved per [`BRANCHING-AND-RELEASE.md`](./BRANCHING-AND-RELEASE.md);
      only signed images with valid provenance are admitted.
- [ ] Post-deploy verification: SLIs healthy, no new alerts, error budget intact.

## Definition of Ready (companion)

Before a story enters a sprint it should be **ready**:

- [ ] Clear problem statement and acceptance criteria.
- [ ] Dependencies identified; design/approach agreed (ADR if significant).
- [ ] Sized small enough to finish in a short-lived branch.
- [ ] Security/observability implications considered up front.
