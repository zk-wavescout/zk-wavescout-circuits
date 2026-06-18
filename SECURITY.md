# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 0.2.x   | ✅ Yes    |
| 0.1.x   | ❌ No     |

## Scope

This repository contains **ZK circuit source code only** — it does not run any servers
or handle user data directly. Security-relevant issues include:

- Constraint bugs that allow a prover to generate a valid proof without knowing the secret
- Wallet-binding weaknesses that allow proof replay under a different address
- Soundness regressions introduced by circuit refactors
- Supply-chain issues in CI tooling (e.g., Nargo installer script)

## Reporting a Vulnerability

Please **do not** open a public GitHub issue for security vulnerabilities.

Report privately via GitHub's
[Security Advisories](https://github.com/zk-wavescout/zk-wavescout-circuits/security/advisories/new)
feature, or email the WaveScout security team. Include:

1. A description of the vulnerability and its impact
2. Steps to reproduce or a minimal proof-of-concept
3. Affected versions (check `Nargo.toml` for the compiler version constraint)

We aim to respond within **72 hours** and to publish a patched release within **14 days**
of a confirmed report.

## Disclosure Policy

We follow coordinated disclosure. We ask that you give us a reasonable window to patch
before publishing details publicly.
