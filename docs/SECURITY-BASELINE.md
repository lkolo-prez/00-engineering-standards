# Security Baseline

These are the **mandatory** controls for every repository in the aircloud organization.
They are non-negotiable defaults; any exception requires a documented, time-boxed waiver
approved by `@aircloud/security` (tracked as an issue with an expiry date).

> Org `aircloud`, registry `ghcr.io/aircloud`, and Azure prefix `aircloud` are example
> placeholders. Replace them on adoption.

## TL;DR — the 12 mandatory controls

1. **SHA-pinned GitHub Actions** — every `uses:` references a full 40-hex commit SHA with a
   trailing version comment. No `@v4`, no `@main`.
2. **Least-privilege tokens** — every workflow sets top-level `permissions: contents: read`
   and elevates per-job only as needed.
3. **Hardened runners** — `step-security/harden-runner` is the first step of every job, with
   `egress-policy: block` (or `audit` while building the allowlist).
4. **Keyless cloud auth** — GitHub OIDC + Azure federated credentials. No long-lived cloud
   secrets in repos or Actions.
5. **SBOM** — generate a CycloneDX SBOM with Syft for every released artifact/image.
6. **Image signing** — cosign **keyless** (Fulcio/Rekor) signatures on every published image.
7. **Provenance** — SLSA build provenance / `actions/attest-build-provenance` for artifacts
   and images (target: SLSA Build L3).
8. **Vulnerability scanning** — Trivy (fs + image), results uploaded to code scanning (SARIF).
9. **SAST** — CodeQL where the language is supported, and/or Semgrep with org rulesets.
10. **Secret scanning** — gitleaks in CI + GitHub secret scanning with push protection enabled.
11. **Dependency hygiene** — Dependabot and/or Renovate, plus `dependency-review` on PRs.
12. **Branch protection** — GitHub Ruleset per [`BRANCH-PROTECTION.md`](./BRANCH-PROTECTION.md):
    2 reviews, CODEOWNERS, signed commits, linear history, no force-push, required checks.

Additionally: **OpenSSF Scorecard** runs weekly and on push to the default branch, and
**pre-commit hooks** mirror the CI lint/format/secret gates locally.

---

## Reference snippets

### SHA-pinned action with hardened runner + least privilege

```yaml
permissions:
  contents: read

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  build:
    runs-on: ubuntu-24.04
    permissions:
      contents: read
      id-token: write      # OIDC for cosign keyless + azure/login
      packages: write      # only if pushing to ghcr.io
    steps:
      - name: Harden the runner
        uses: step-security/harden-runner@0080882f6c36860b6ba35c610c98ce87d4e2f26f # v2.10.2
        with:
          egress-policy: block
          allowed-endpoints: >
            github.com:443
            ghcr.io:443
            fulcio.sigstore.dev:443
            rekor.sigstore.dev:443
      - name: Checkout
        uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
```

### Keyless cloud auth (Azure OIDC)

```yaml
      - name: Azure login (OIDC, no secrets)
        uses: azure/login@a457da9ea143d694b1b9c7c869ebb04ebe844ef5 # v2.3.0
        with:
          client-id: ${{ vars.AZURE_CLIENT_ID }}
          tenant-id: ${{ vars.AZURE_TENANT_ID }}
          subscription-id: ${{ vars.AZURE_SUBSCRIPTION_ID }}
```

### SBOM + keyless sign + provenance

```yaml
      - name: Generate SBOM (CycloneDX)
        uses: anchore/sbom-action@f325610c9f50a54015d37c8d16cb3b0e2c8f4de0 # v0.18.0
        with:
          format: cyclonedx-json
          output-file: sbom.cdx.json
      - name: Install cosign
        uses: sigstore/cosign-installer@d7d6bc7722e3daa8354c50bcb52f4837da5e9b6a # v3.8.1
      - name: Sign image (keyless)
        run: cosign sign --yes "ghcr.io/aircloud/${{ github.event.repository.name }}@${DIGEST}"
      - name: Attest build provenance
        uses: actions/attest-build-provenance@520d128f165991a6c774bcb264f323e3d70747f4 # v2.2.0
        with:
          subject-name: ghcr.io/aircloud/${{ github.event.repository.name }}
          subject-digest: ${{ env.DIGEST }}
          push-to-registry: true
```

> Pin examples above are illustrative; always verify the SHA for the tag you intend to use
> (e.g. `gh api repos/<owner>/<repo>/commits/<tag> -q .sha`) before committing.

---

## Control matrix

This table maps each baseline control to the relevant external framework so auditors and
engineers share one view. Coverage marks: ✅ direct, 🟡 partial/contributing.

| # | Control | Implemented by | SLSA L3 | OpenSSF Scorecard | NIST SSDF | OWASP ASVS v4 | CIS | SOC 2 (TSC) |
| --- | --- | --- | :---: | :---: | :---: | :---: | :---: | :---: |
| 1 | SHA-pinned actions | Renovate/Dependabot digest pinning, CI lint | ✅ | `Pinned-Dependencies` ✅ | PW.4, PO.3 | V14.2 | CIS SW Supply Chain 2.4 | CC8.1 |
| 2 | Least-privilege `GITHUB_TOKEN` | Per-workflow `permissions:` | 🟡 | `Token-Permissions` ✅ | PO.5 | V1.4 | 5.x | CC6.1, CC6.3 |
| 3 | Harden-runner (egress block) | `step-security/harden-runner` | 🟡 | `Dangerous-Workflow` 🟡 | PW.6 | V14.1 | 4.x | CC6.6, CC7.1 |
| 4 | OIDC keyless cloud auth | `azure/login` federated creds | 🟡 | `Token-Permissions` 🟡 | PO.5, PS.1 | V2.10 | 1.1.x | CC6.1, CC6.6 |
| 5 | SBOM (CycloneDX) | Syft / `sbom-action` | ✅ | n/a | PS.3, RV.1 | V14.2 | SW Supply Chain 3.x | CC7.1 |
| 6 | Image signing (cosign keyless) | Sigstore Fulcio/Rekor | ✅ | `Signed-Releases` ✅ | PS.2 | V14.2 | SW Supply Chain 4.x | CC8.1 |
| 7 | SLSA build provenance | `attest-build-provenance` | ✅ | `Signed-Releases` 🟡 | PS.3, PW.6 | V14.2 | SW Supply Chain 4.x | CC8.1 |
| 8 | Vulnerability scanning (Trivy) | CI + SARIF upload | 🟡 | `Vulnerabilities` ✅ | RV.1, RV.2 | V14.2 | 5.x | CC7.1, CC7.2 |
| 9 | SAST (CodeQL/Semgrep) | CI code scanning | 🟡 | `SAST` ✅ | PW.7, PW.8 | V1.1 | n/a | CC7.1 |
| 10 | Secret scanning (gitleaks + push protection) | CI + GitHub advanced security | 🟡 | n/a | PW.4, RV.1 | V2.10, V6.4 | n/a | CC6.1 |
| 11 | Dependency review + Dependabot/Renovate | PR gate + bots | 🟡 | `Dependency-Update-Tool` ✅ | PW.4, RV.1 | V14.2 | SW Supply Chain 2.x | CC7.1, CC8.1 |
| 12 | Branch protection (Ruleset) | GitHub Ruleset | 🟡 | `Branch-Protection`, `Code-Review` ✅ | PO.3, PW.7 | V1.14 | n/a | CC8.1, CC6.1 |
| + | OpenSSF Scorecard workflow | `ossf/scorecard-action` | 🟡 | self ✅ | PO.3 | n/a | n/a | CC4.1 |
| + | Pre-commit hooks | `pre-commit` mirroring CI | 🟡 | n/a | PW.7 | n/a | n/a | CC8.1 |
| + | Signed (verified) commits | GitHub Ruleset `required_signatures` | 🟡 | n/a | PW.4 | V1.14 | n/a | CC8.1 |

### Framework legend

- **SLSA L3** — [Supply-chain Levels for Software Artifacts](https://slsa.dev) Build track,
  Level 3 (hardened, non-falsifiable provenance).
- **OpenSSF Scorecard** — automated checks; we target a score **≥ 8.0** on every repo.
- **NIST SSDF** — [NIST SP 800-218](https://csrc.nist.gov/pubs/sp/800/218/final) Secure
  Software Development Framework practices (PO/PS/PW/RV).
- **OWASP ASVS** — [Application Security Verification Standard](https://owasp.org/www-project-application-security-verification-standard/).
- **CIS** — CIS Benchmarks + CIS Software Supply Chain Security Guide.
- **SOC 2** — AICPA Trust Services Criteria (Common Criteria CC-series).

## Enforcement

- **CI** fails the build when a control is missing (e.g. an unpinned action, missing SBOM).
- **OpenSSF Scorecard** results are published as a badge; a drop below 8.0 opens an issue.
- **Org rulesets** prevent merging without the required status checks.
- **Quarterly review** — `@aircloud/security` audits waivers and Scorecard trends.

## Waivers

A waiver is an issue labeled `security-waiver` with: the control being waived, the
justification, the compensating control, an owner, and an **expiry date** (max 90 days).
Expired waivers auto-reopen the blocking issue.
