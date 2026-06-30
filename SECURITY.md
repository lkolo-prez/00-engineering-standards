# Security Policy

aircloud takes security seriously, including for this documentation repository. Because this
repo defines the org-wide [security baseline](./docs/SECURITY-BASELINE.md), accuracy here is
itself a security control.

> `aircloud` is an example placeholder org name. Replace contact details on adoption.

## Reporting a vulnerability (private disclosure)

**Do not open a public issue, PR, or discussion for security problems.**

Report privately via one of:

1. **GitHub Private Vulnerability Reporting** — preferred. On this repo: **Security → Report a
   vulnerability** (GitHub Security Advisories). This keeps the report private until a fix is
   ready.
2. **Email** — `security@aircloud.example` (PGP key fingerprint published at the URL in our
   `security.txt`). Encrypt sensitive details.

Please include: affected file/area, a clear description, reproduction or proof-of-concept, and
the impact you foresee. For this docs repo, "vulnerabilities" include guidance that would lead
adopters to insecure configurations (e.g. an unsafe example), as well as leaked secrets or
malicious content in templates.

### security.txt

Our machine-readable contact info follows [RFC 9116](https://www.rfc-editor.org/rfc/rfc9116)
and is published at:

```
https://aircloud.example/.well-known/security.txt
```

It points back to this policy and the reporting channels above.

## Our commitment (SLA)

| Stage | Target |
| --- | --- |
| **Acknowledge** receipt | within **2 business days** |
| **Triage** + initial severity | within **5 business days** |
| **Fix or mitigation** for Critical/High | within **30 days** |
| **Fix or mitigation** for Medium/Low | within **90 days** |
| **Coordinated disclosure** | by mutual agreement once a fix is available |

We follow coordinated disclosure and will credit reporters who wish to be acknowledged.

## Scope

- **In scope:** content of this repository (docs, examples, workflows, config), the CI
  workflows here, and any insecure guidance that could harm adopters.
- **Out of scope:** issues in the downstream template/product repositories — report those to
  the respective repo's `SECURITY.md`. Social engineering and physical attacks are out of scope.

## Supported versions

The handbook is continuously maintained; only the latest released version (and `main`) is
supported. See [`CHANGELOG.md`](./CHANGELOG.md) for history.

## Safe harbor

We will not pursue or support legal action against researchers who act in good faith, follow
this policy, avoid privacy violations and service disruption, and give us reasonable time to
remediate before disclosure.
