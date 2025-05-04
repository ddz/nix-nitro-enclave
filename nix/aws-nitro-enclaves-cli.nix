{ pkgs ? import <nixpkgs> { } }:

# gcc, make, git, llvm-dev, libclang-dev, clang
# Set NITRO_CLI_INSTALL_DIR to the desired location, by default everything will be installed in build/install
# make nitro-cli && make vsock-proxy && make install'
# Rust 1.71.1

pkgs.rustPlatform.buildRustPackage {
  pname = "aws-nitro-enclaves-cli";
  version = "0.0.0";

  src = pkgs.lib.cleanSource ./.;

  cargoLock.lockFile = ./Cargo.lock;

  # to only build nitro-cli and vsock-proxy
  # buildAndTestSubdir = "...";

  nativeBuildInputs = [ 
    pkgs.pkg-config 
  ];

  buildInputs = [
    pkgs.openssl
  ];

  doCheck = false;
}
