{ pkgs ? import <nixpkgs> {} }:

let
  ghcWithPkgs = pkgs.haskellPackages.ghcWithPackages (p: [
    p.base
    p.text
  ]);
in pkgs.mkShell {
  buildInputs = [
    (pkgs.agda.withPackages (p: [ p.standard-library ]))
    ghcWithPkgs
    pkgs.cabal-install
  ];
}
