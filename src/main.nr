use dep::std;

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
