.PHONY: compile test prove verify clean

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
