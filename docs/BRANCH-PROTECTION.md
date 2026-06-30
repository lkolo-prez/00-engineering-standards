# Branch Protection (GitHub Rulesets)

Every aircloud repository protects its default branch (`main`) with a **GitHub Ruleset**.
Rulesets are preferred over legacy branch-protection rules: they are layered, org-applicable,
and exportable as JSON. This page documents the standard ruleset and how to apply it via the
GitHub UI, the `gh` CLI, and Terraform.

> Org `aircloud` is an example placeholder.

## The standard ruleset

Applied to `~DEFAULT_BRANCH` (and release branches `release/*` where used):

| Rule | Setting |
| --- | --- |
| Require a pull request before merging | **on** |
| Required approvals | **2** |
| Dismiss stale approvals on new commits | **on** |
| Require review from Code Owners | **on** (CODEOWNERS) |
| Require approval of the most recent push | **on** |
| Require conversation resolution | **on** |
| Require status checks to pass | **on** (see list below) |
| Require branches up to date before merge | **on** |
| Require signed commits | **on** |
| Require linear history | **on** |
| Block force pushes | **on** |
| Restrict deletions | **on** |
| Restrict who can push (bypass) | org admins only, with logging; ideally none |

### Required status checks

The exact check names must match your CI job names. The standard set:

- `lint`
- `format-check`
- `typecheck`
- `test`
- `coverage` (fails below the threshold, default **80%** lines/branches)
- `build`
- `security` (Trivy + gitleaks aggregate)
- `codeql` (or `semgrep`)
- `dependency-review`

For this docs repo specifically, the required checks are `docs-lint` (markdownlint + lychee +
vale) and `scorecard`.

### Signed commits

Commits to `main` must be **verified**. Configure local signing once:

```bash
# Recommended: SSH signing (simplest with GitHub)
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true
# Add the SAME key to GitHub as a "Signing key" (Settings → SSH and GPG keys).
```

GPG and `gitsign` (keyless, Sigstore-backed) are also accepted. CI rejects unsigned commits on
protected branches.

---

## Apply via the GitHub UI

Repo (or org) → **Settings → Rules → Rulesets → New ruleset → New branch ruleset**, set
**Enforcement: Active**, target the default branch, and toggle the rules above. Save. For
org-wide application, create the ruleset at the **organization** level and target all repos
(or a repo property filter such as `golden-path: true`).

## Apply via `gh` CLI

Export the ruleset to JSON once, then apply it to many repos. Save the following as
`ruleset.json`:

```json
{
  "name": "default-branch-protection",
  "target": "branch",
  "enforcement": "active",
  "conditions": {
    "ref_name": { "include": ["~DEFAULT_BRANCH"], "exclude": [] }
  },
  "rules": [
    { "type": "deletion" },
    { "type": "non_fast_forward" },
    { "type": "required_linear_history" },
    { "type": "required_signatures" },
    {
      "type": "pull_request",
      "parameters": {
        "required_approving_review_count": 2,
        "dismiss_stale_reviews_on_push": true,
        "require_code_owner_review": true,
        "require_last_push_approval": true,
        "required_review_thread_resolution": true
      }
    },
    {
      "type": "required_status_checks",
      "parameters": {
        "strict_required_status_checks_policy": true,
        "required_status_checks": [
          { "context": "lint" },
          { "context": "format-check" },
          { "context": "typecheck" },
          { "context": "test" },
          { "context": "coverage" },
          { "context": "build" },
          { "context": "security" },
          { "context": "codeql" },
          { "context": "dependency-review" }
        ]
      }
    }
  ]
}
```

Apply to a single repo:

```bash
gh api -X POST repos/aircloud/<repo>/rulesets \
  --input ruleset.json -H "Accept: application/vnd.github+json"
```

Apply org-wide (loop over repos, or create one org-level ruleset):

```bash
# Org-level ruleset (targets all repos by default)
gh api -X POST orgs/aircloud/rulesets \
  --input ruleset.json -H "Accept: application/vnd.github+json"

# Or per-repo for a list:
for r in $(gh repo list aircloud --json name -q '.[].name'); do
  gh api -X POST "repos/aircloud/$r/rulesets" --input ruleset.json \
    -H "Accept: application/vnd.github+json" || echo "skip $r"
done
```

## Apply via Terraform (github provider)

Manage rulesets as code so they are reviewed and versioned. Use OIDC or a fine-grained PAT in
CI — never a long-lived org-admin secret in plaintext.

```hcl
terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.3"
    }
  }
}

provider "github" {
  owner = "aircloud"
}

variable "repository" { type = string }

resource "github_repository_ruleset" "default_branch" {
  name        = "default-branch-protection"
  repository  = var.repository
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    deletion                = true
    non_fast_forward        = true # block force-push
    required_linear_history = true
    required_signatures     = true

    pull_request {
      required_approving_review_count   = 2
      dismiss_stale_reviews_on_push     = true
      require_code_owner_review         = true
      require_last_push_approval        = true
      required_review_thread_resolution = true
    }

    required_status_checks {
      strict_required_status_checks_policy = true
      required_check { context = "lint" }
      required_check { context = "format-check" }
      required_check { context = "typecheck" }
      required_check { context = "test" }
      required_check { context = "coverage" }
      required_check { context = "build" }
      required_check { context = "security" }
      required_check { context = "codeql" }
      required_check { context = "dependency-review" }
    }
  }
}
```

For org-wide application use `github_organization_ruleset` with a repository-name or
repository-property condition (e.g. only repos with the custom property `golden-path = true`).

## Verifying enforcement

```bash
# List rulesets on a repo
gh api repos/aircloud/<repo>/rulesets -q '.[].name'

# Confirm a push of an unsigned commit to main is rejected (expected: blocked)
gh api repos/aircloud/<repo>/rules/branches/main -q '.[].type'
```

A repo is non-compliant if any of: fewer than 2 reviews, CODEOWNERS not required, signed
commits off, force-push allowed, or required checks missing. The platform team runs a weekly
audit and opens issues on drift.
