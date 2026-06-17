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

## Prover.toml format
```toml
secret_solution = "42"
public_puzzle_hash = "<poseidon output>"
contributor_wallet = "<your stellar address as field>"
```

## Commit style
Follow [Conventional Commits](https://www.conventionalcommits.org): `type(scope): message`
