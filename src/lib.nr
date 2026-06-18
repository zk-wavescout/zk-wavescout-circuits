use dep::std;

/// Hash a single field element using Poseidon/BN254.
///
/// This is the canonical hash primitive used across the WaveScout circuit suite.
/// All on-chain puzzle hashes are expected to be produced by this function.
///
/// # Example
/// ```
/// let h = poseidon1(42);
/// assert(h == std::hash::poseidon::bn254::hash_1([42]));
/// ```
pub fn poseidon1(x: Field) -> Field {
    std::hash::poseidon::bn254::hash_1([x])
}

/// Hash two field elements using Poseidon/BN254.
///
/// Uses `std::hash::poseidon::bn254::hash_2` (not hash_1 called twice).
/// Useful for commitment schemes that bind two values together (e.g., secret + salt,
/// or secret + nonce to produce a per-instance commitment).
pub fn poseidon2(x: Field, y: Field) -> Field {
    std::hash::poseidon::bn254::hash_2([x, y])
}

/// Produce a salted commitment: Poseidon(secret, salt).
///
/// Use this when the same secret may appear in multiple puzzles and you want
/// each proof instance to be distinguishable.
pub fn salted_commitment(secret: Field, salt: Field) -> Field {
    poseidon2(secret, salt)
}

// ── tests ────────────────────────────────────────────────────────────────────

#[test]
fn test_poseidon1_deterministic() {
    assert(poseidon1(1) == poseidon1(1));
}

#[test]
fn test_poseidon1_zero() {
    // zero is a valid field element; hash must not panic or produce a tautology
    let h = poseidon1(0);
    assert(h != 0);
}

#[test]
fn test_poseidon1_collision_resistance() {
    assert(poseidon1(1) != poseidon1(2));
}

#[test]
fn test_poseidon2_deterministic() {
    assert(poseidon2(1, 2) == poseidon2(1, 2));
}

#[test]
fn test_poseidon2_order_matters() {
    assert(poseidon2(1, 2) != poseidon2(2, 1));
}

#[test]
fn test_salted_commitment_differs_from_plain_hash() {
    let secret: Field = 42;
    let salt: Field = 1;
    assert(salted_commitment(secret, salt) != poseidon1(secret));
}

#[test]
fn test_salted_commitment_same_secret_different_salts() {
    let secret: Field = 42;
    assert(salted_commitment(secret, 1) != salted_commitment(secret, 2));
}

#[test(should_fail)]
fn test_salted_commitment_not_symmetric() {
    // salted_commitment(a, b) != salted_commitment(b, a) in general
    let a: Field = 1;
    let b: Field = 2;
    assert(salted_commitment(a, b) == salted_commitment(b, a));
}
