# Changelog

All notable changes to the aircloud engineering handbook are documented here. This file is
maintained automatically by [release-please](https://github.com/googleapis/release-please) from
[Conventional Commits](https://www.conventionalcommits.org). Do not edit it by hand.

## [0.1.1](https://github.com/lkolo-prez/00-engineering-standards/compare/v0.1.0...v0.1.1) (2026-11-25)


### Documentation

* point contacts to AIRCLOUD (lkolo-prez, office@aircloud.com.pl) ([deed310](https://github.com/lkolo-prez/00-engineering-standards/commit/deed310f15bd4928ea7dc3f67acddf8c1c45a3ea))
* **readme:** AIRCLOUD golden-path header, usage and footer ([f354d11](https://github.com/lkolo-prez/00-engineering-standards/commit/f354d11c0fe1d4f24ff5911efe2b6b6d1548733a))


### CI/CD

* fix red main pipelines (links, gitleaks, docs-lint, scorecard) ([19fc1b9](https://github.com/lkolo-prez/00-engineering-standards/commit/19fc1b9d9f975760276852dd9be4a037533b3b0e))

## 0.1.0 (unreleased)

### Features

- Initial engineering handbook: golden paths, security baseline (with SLSA/Scorecard/SSDF/ASVS/
  CIS/SOC 2 control matrix), AI-assistant standard, branching & release, branch protection,
  threat-model template, observability, incident response, code review, and definition of done.
- Template catalog and architecture overview with runbooks.
- Self-applying supply-chain controls: SHA-pinned actions, harden-runner, least-privilege
  permissions, OpenSSF Scorecard, gitleaks, dependency-review, Dependabot/Renovate, pre-commit.
