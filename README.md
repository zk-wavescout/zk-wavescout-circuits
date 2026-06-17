# zk-wavescout-circuits

![CI](https://github.com/zk-wavescout/zk-wavescout-circuits/actions/workflows/ci.yml/badge.svg)

Noir ZK circuit for the WaveScout trustless bounty system. Proves knowledge of a secret preimage `s` such that `Poseidon(s) == public_puzzle_hash`, while binding the proof to a specific `contributor_wallet` to prevent front-running.

## Inputs

| Name | Visibility | Description |
|---|---|---|
| `secret_solution` | private | The contributor's secret answer |
| `public_puzzle_hash` | public | Target hash stored in the Soroban contract |
| `contributor_wallet` | public | Claimant's Stellar address — non-transferable binding |

## Usage

```bash
nargo compile          # → target/zk_wavescout.json
nargo test             # run all tests
nargo prove            # generate proof (edit Prover.toml first)
nargo verify           # verify proof
```

## Cross-repo links
- **Contracts**: `zk-wavescout-contracts` — consumes the verifying key from the compiled artifact
- **Coordinator**: `zk-wavescout-coordinator` — runs proof generation in the browser via `@noir-lang/noir_js`
