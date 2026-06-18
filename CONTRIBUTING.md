# Contributing

## Prerequisites
- [Nargo](https://noir-lang.org/docs/getting_started/installation) >= 0.30.0

## Workflow
```bash
nargo compile   # compile circuit → target/zk_wavescout.json
nargo test      # run all #[test] functions
nargo prove     # generate a proof (requires Prover.toml)
nargo verify    # verify a proof
```

Or use the `Makefile`:
```bash
make compile
make test
make prove
make verify
```

## Prover.toml format
```toml
secret_solution = "42"
public_puzzle_hash = "<poseidon output>"
contributor_wallet = "<your stellar address as field>"
```

## Encoding a Stellar address as a field element

Stellar account IDs are 32-byte Ed25519 public keys encoded in Strkey (`G…`) format.
To get the field element value for `contributor_wallet`:

1. Decode the Strkey to raw bytes:
   ```python
   import base64, struct
   # stellar_sdk or manual base32 decode
   raw_bytes = strkey_decode(account_id)  # 32 bytes
   ```
2. Interpret as a big-endian unsigned integer:
   ```python
   field_int = int.from_bytes(raw_bytes, "big")
   contributor_wallet = hex(field_int)  # use this in Prover.toml
   ```
3. The value must be less than the BN254 scalar field modulus:
   `0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001`

## Commit style
Follow [Conventional Commits](https://www.conventionalcommits.org): `type(scope): message`

Common types: `fix`, `feat`, `test`, `docs`, `ci`, `refactor`, `chore`

## Troubleshooting

### `nargo: command not found`
Run the installer and add the binary to your PATH:
```bash
curl -L https://raw.githubusercontent.com/noir-lang/noirup/main/install | bash
echo 'export PATH="$HOME/.nargo/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### `Cannot satisfy constraint` in tests
Make sure the hash in `Prover.toml` was generated from the same `secret_solution` using
`std::hash::poseidon::bn254::hash_1`. A mismatch means the puzzle hash is stale.

### Proof verification fails after editing the circuit
Any change to `src/main.nr` changes the proving key. Delete `proofs/` and regenerate:
```bash
rm -rf proofs/ target/
nargo compile && nargo prove
```
