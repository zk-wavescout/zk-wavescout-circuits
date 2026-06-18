.PHONY: compile test prove verify clean help

help:
	@echo "make compile  — compile circuit to target/zk_wavescout.json"
	@echo "make test     — run all #[test] functions"
	@echo "make prove    — generate a proof (edit Prover.toml first)"
	@echo "make verify   — verify proof against Verifier.toml"
	@echo "make clean    — remove target/ and proofs/"

compile:
	nargo compile

test:
	nargo test

prove:
	nargo prove

verify:
	nargo verify

clean:
	rm -rf target/ proofs/
