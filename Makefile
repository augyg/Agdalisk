.PHONY: generate clean typecheck

# Typecheck all Agda files (verifies proofs)
typecheck:
	cd agda && agda Ace/Access.agda
	cd agda && agda Ace/Subscription.agda
	cd agda && agda Ace/Protocol.agda

# Generate Haskell from Agda via GHC backend
generate:
	cd agda && agda --compile --ghc-dont-call-ghc Main.agda
	rm -rf ../generated/MAlonzo
	cp -r agda/MAlonzo ../generated/

clean:
	rm -rf agda/MAlonzo agda/*.agdai agda/Ace/*.agdai generated/MAlonzo
