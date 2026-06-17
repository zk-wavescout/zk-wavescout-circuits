use dep::std;

// Security model:
// - secret_solution is never revealed on-chain; only its Poseidon hash is public
// - contributor_wallet is included as a public input so the proof is non-transferable
fn main(
    secret_solution: Field,
    public_puzzle_hash: pub Field,
    contributor_wallet: pub Field,
) {
    let computed_hash = std::hash::poseidon::bn254::hash_1([secret_solution]);
    assert(computed_hash == public_puzzle_hash);

    // Bind wallet: prevents a front-runner from reusing this proof under a different address
    let _bind = contributor_wallet;
}

#[test]
fn test_valid_submission() {
    let secret: Field = 42;
    let hash = std::hash::poseidon::bn254::hash_1([secret]);
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
    let hash_a = std::hash::poseidon::bn254::hash_1([1]);
    let hash_b = std::hash::poseidon::bn254::hash_1([2]);
    assert(hash_a != hash_b);
}

#[test]
fn test_zero_secret_is_valid() {
    let secret: Field = 0;
    let hash = std::hash::poseidon::bn254::hash_1([secret]);
    main(secret, hash, 0x01);
}
