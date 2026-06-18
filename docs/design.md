# Circuit Design Notes

## Overview

The `zk_wavescout` circuit proves two things in a single proof:

1. **Preimage knowledge** — the prover knows a secret value `s` whose Poseidon hash
   equals the on-chain `public_puzzle_hash`.
2. **Wallet binding** — the proof is cryptographically tied to a specific
   `contributor_wallet` so it cannot be replayed by a different address.

## Why Poseidon/BN254?

Poseidon is a ZK-friendly hash function designed to minimise the number of field
multiplications per hash, making it cheap to verify inside an arithmetic circuit.
BN254 (alt_bn128) is the curve targeted by the Barretenberg proving backend used by
Nargo. Using the same curve for both the circuit and the backend avoids a hash
function mismatch that would cause a soundness failure.

## Wallet Binding Mechanism

The wallet address is passed as a **public input**. This means:

- The Soroban verifier can read it directly from the proof public inputs.
- The contract compares it to `tx.source_account` (the transaction sender).
- A mismatch causes the contract to reject the proof, preventing front-running.

The wallet is additionally hashed inside the circuit (via Poseidon) so the constraint
is included in the R1CS instance and cannot be stripped by a malicious prover.

## Threat Model

| Threat | Mitigation |
|--------|-----------|
| Attacker submits valid proof for a different wallet | Wallet is a public input; contract checks it against `tx.source_account` |
| Attacker brute-forces secret from `public_puzzle_hash` | Poseidon pre-image resistance; secret space assumed large |
| Prover omits wallet constraint | `wallet_commitment != public_puzzle_hash` is enforced in R1CS; omitting it breaks proof generation |
| Replay of an old proof | `public_puzzle_hash` is per-bounty; solved puzzles are closed on-chain |

## Field Encoding

Stellar account IDs are 32-byte Ed25519 public keys. When encoded as a BN254 scalar:

- Interpret the 32 bytes as a big-endian unsigned integer.
- The result must be `< 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001`
  (the BN254 scalar field modulus).
- In practice, Ed25519 keys are always below this bound.

## Future Improvements

- Add a `nonce` input to make each proof instance unique and prevent replay
  at the ZK layer (currently handled purely by contract state).
- Support batch proving multiple bounty claims in a single proof using
  Noir's recursion feature.
