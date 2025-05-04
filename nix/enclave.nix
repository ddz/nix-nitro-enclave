{ pkgs ? import <nixpkgs> { } }:

pkgs.buildGoModule rec {
  pname = "enclave";
  version = "0.0.0";

  src = ./../src/enclave;

  vendorHash = "sha256-+CH2Z9jaZaBzylsQkVBIfMANNcRHKi5ZKdhz5HQdNi8=";
}
