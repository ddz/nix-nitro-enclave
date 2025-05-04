{ pkgs ? import <nixpkgs> { } }:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "vhost-device-vsock";
  version = "0.2.0-141-gf6f4a90";

  src = pkgs.fetchFromGitHub {
    owner = "rust-vmm";
    repo = "vhost-device";
    rev = "f6f4a90";
    hash = "sha256-bfE9kKPhbWKS1lKMs71Qsjoaga67sD1m69f8PbPBa3s=";
  };

  # Tests use VMADDR_CID_LOCAL, need to modprobe vsock_loopback
  
  # only want this subproj
  buildAndTestSubdir = "vhost-device-vsock";

  cargoHash = "sha256-lHT2YZ6NfHIosybXs4ztFODsnyLHoOf4Fh3vnL7jJ5s=";
  
  nativeBuildInputs = [
    pkgs.pkg-config
    pkgs.rustPlatform.bindgenHook
  ];
}
