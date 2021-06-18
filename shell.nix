{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell rec {
  parsec = pkgs.callPackage ./parsec.nix { };
  buildInputs = [ parsec ];
}
