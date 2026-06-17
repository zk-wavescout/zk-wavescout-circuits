use dep::std;

fn main(
    secret_solution: Field,
    public_puzzle_hash: pub Field,
    contributor_wallet: pub Field,
) {
    // TODO: bind contributor_wallet to the proof to prevent front-running
    let computed_hash = std::hash::poseidon::bn254::hash_1([secret_solution]);
    assert(computed_hash == public_puzzle_hash);
}
