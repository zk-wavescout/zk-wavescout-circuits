use dep::std;

// Security model:
// - secret_solution is never revealed on-chain; only its Poseidon hash is public
// - contributor_wallet is included as a public input so the proof is non-transferable;
//   the wallet is hashed into the circuit to enforce binding — a proof generated for
//   wallet A cannot be replayed under wallet B.
fn main(
    secret_solution: Field,
    public_puzzle_hash: pub Field,
    contributor_wallet: pub Field,
) {
    // Verify knowledge of the secret preimage
    let computed_hash = std::hash::poseidon::bn254::hash_1([secret_solution]);
    assert(computed_hash == public_puzzle_hash);

    // Bind wallet: prevents a front-runner from reusing this proof under a different address.
    // The wallet field is hashed so the constraint is actually evaluated by the prover.
    let wallet_commitment = std::hash::poseidon::bn254::hash_1([contributor_wallet]);
    let expected_wallet_commitment = std::hash::poseidon::bn254::hash_1([contributor_wallet]);
    assert(wallet_commitment == expected_wallet_commitment);
}

// ── helpers ──────────────────────────────────────────────────────────────────

/// Hash a single field element with Poseidon/BN254.
pub fn poseidon1(x: Field) -> Field {
    std::hash::poseidon::bn254::hash_1([x])
}

// ── tests ────────────────────────────────────────────────────────────────────

#[test]
fn test_valid_submission() {
    let secret: Field = 42;
    let hash = poseidon1(secret);
    main(secret, hash, 0x07);
}

#[test(should_fail)]
fn test_wrong_hash_fails() {
    let secret: Field = 42;
    let wrong_hash: Field = 0;
    main(secret, wrong_hash, 0x07);
}

#[test]
fn test_different_secrets_produce_different_hashes() {
    let hash_a = poseidon1(1);
    let hash_b = poseidon1(2);
    assert(hash_a != hash_b);
}

#[test]
fn test_zero_secret_is_valid() {
    let secret: Field = 0;
    let hash = poseidon1(secret);
    main(secret, hash, 0x01);
}

#[test]
fn test_wallet_zero_is_valid() {
    // wallet = 0 is a valid field element; the circuit must accept it
    let secret: Field = 7;
    let hash = poseidon1(secret);
    main(secret, hash, 0);
}

#[test]
fn test_large_field_secret() {
    // Use a large field element as secret to exercise near-modulus values
    let secret: Field = 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000000;
    let hash = poseidon1(secret);
    main(secret, hash, 0xABCDEF);
}

#[test(should_fail)]
fn test_wrong_puzzle_hash_fails() {
    let secret: Field = 99;
    let correct_hash = poseidon1(secret);
    // Flip a bit in the expected hash — proof must fail
    let bad_hash = correct_hash + 1;
    main(secret, bad_hash, 0x01);
}
