# Changelog

All notable changes to this project will be documented in this file.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [0.2.0] — 2026-06-18

### Fixed
- Wallet binding now uses an actual Poseidon hash constraint instead of a dead `_bind` variable
- `Nargo.toml` authors field corrected to `zk-wavescout contributors`

### Added
- `src/lib.nr` with reusable `poseidon1` and `poseidon2` helpers
- Tests: `test_wallet_zero_is_valid`, `test_large_field_secret`, `test_wrong_puzzle_hash_fails`
- `SECURITY.md` with vulnerability disclosure policy
- `Makefile` with common developer commands
- CI: `nargo verify` smoke-test step and Nargo binary caching

### Changed
- `Prover.toml` and `Verifier.toml` now include inline comments explaining each field
- `.gitignore` extended with `.DS_Store`, editor dirs, and `.env` files
- CONTRIBUTING guide extended with Stellar address field-encoding instructions and troubleshooting

---

## [0.1.0] — 2026-06-17

### Added
- Initial Noir circuit: Poseidon/BN254 preimage constraint + wallet binding
- `#[test]` suite: valid submission, wrong hash, boundary values
- GitHub Actions CI: compile, test, prove smoke-test
- `Prover.toml` and `Verifier.toml` with inline field documentation
- PR template and initial CONTRIBUTING guide
