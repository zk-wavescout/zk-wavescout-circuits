# zk-wavescout-circuits

![CI](https://github.com/zk-wavescout/zk-wavescout-circuits/actions/workflows/ci.yml/badge.svg)

Noir ZK circuit for the WaveScout trustless bounty system. Proves knowledge of a secret preimage `s` such that `Poseidon(s) == public_puzzle_hash`, while binding the proof to a specific `contributor_wallet` to prevent front-running.

## Inputs

| Name | Visibility | Description |
|---|---|---|
| `secret_solution` | private | The contributor's secret answer |
| `public_puzzle_hash` | public | Target hash stored in the Soroban contract |
| `contributor_wallet` | public | Claimant's Stellar address encoded as a BN254 field element |

## Usage

```bash
nargo compile          # → target/zk_wavescout.json
nargo test             # run all tests
nargo prove            # generate proof (edit Prover.toml first)
nargo verify           # verify proof
```

Or via the Makefile:

```bash
make compile
make test
make prove
make verify
make clean
```

## Circuit Architecture

```
main(secret_solution, public_puzzle_hash, contributor_wallet)
│
├── constraint 1 — preimage knowledge
│   computed_hash = Poseidon/BN254(secret_solution)
│   assert computed_hash == public_puzzle_hash
│
└── constraint 2 — wallet binding
    wallet_commitment = Poseidon/BN254(contributor_wallet)
    assert wallet_commitment != public_puzzle_hash
    (public input pins contributor_wallet; verifier checks it matches on-chain value)
```

The wallet is included as a **public input** so the Soroban contract verifier can assert
it equals the transaction sender's address. This makes the proof non-transferable: a proof
generated for wallet `A` will fail verification when submitted from wallet `B`.

### Hash primitive

All hashing uses **Poseidon over BN254** (`std::hash::poseidon::bn254::hash_1`), which is
the same curve used by the Barretenberg backend and is cheap to verify in Solidity / WASM.

### Reusable helpers

`src/lib.nr` exports `poseidon1(x)` and `poseidon2(x, y)` for use in sibling circuits.

## Cross-repo links

| Repo | Role |
|---|---|
| [zk-wavescout-contracts](https://github.com/zk-wavescout/zk-wavescout-contracts) | Soroban contracts — consume the verifying key from `target/zk_wavescout.json` |
| [zk-wavescout-coordinator](https://github.com/zk-wavescout/zk-wavescout-coordinator) | Browser coordinator — runs proof generation via `@noir-lang/noir_js` |
