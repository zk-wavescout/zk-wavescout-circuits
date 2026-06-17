# zk-wavescout-circuits
Written in Noir (a Rust-like DSL for ZK-SNARKs), this circuit verifies that the contributor has found a secret preimage $s$ which hashes to the public puzzle threshold $H$ ($H = \text{Poseidon}(s)$). It also binds the contributor's public Stellar address to prevent front-running.
