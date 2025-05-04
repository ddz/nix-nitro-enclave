{
  description = "Nix Nitro Enclave";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nitro-util.url = "github:monzo/aws-nitro-util";
  };

  outputs = { self, nixpkgs, nitro-util, ... }: 
  let
    arch = "x86_64";
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    nitro = nitro-util.lib.x86_64-linux;

    gitUrl = "https://github.com/ddz/nix-nitro-enclave";
    gitRev = self.dirtyRev or self.rev;

    enclave = pkgs.callPackage ./nix/enclave.nix { };
    
    # Add libcbor input to build qemu w/ nitro-enclave machine type
    qemuNitroEnclave = pkgs.qemu.overrideAttrs (finalAttrs: previousAttrs: {
      buildInputs = previousAttrs.buildInputs ++ [ pkgs.libcbor ];
    });

    # Usermode vsock backend for development and testing outside of EC2
    vhostDeviceVsock = pkgs.callPackage ./nix/vhost-device-vsock.nix { };

    rootfs =  pkgs.buildEnv {
      name = "enclave-rootfs";
      paths = [ enclave ];
      pathsToLink = [ "/bin" ];
    };

  in {
    # Run enclave app locally for development and testing
    apps.x86_64-linux.default = {
      type = "app";
      program = "${enclave}/bin/enclave";
    };
    
    devShells.x86_64-linux.default = pkgs.mkShell {
      buildInputs = [
        pkgs.go pkgs.socat qemuNitroEnclave vhostDeviceVsock
      ];
    };

    # Default package to build is the enclave image
    packages.x86_64-linux.default = self.packages.x86_64-linux.enclave;
    
    # Build app as an EIF to run in AWS Nitro Enclaves 
    packages.x86_64-linux.enclave = nitro.buildEif {
      kernel = nitro.blobs.${arch}.kernel;
      kernelConfig = nitro.blobs.${arch}.kernelConfig;

      name = enclave.pname;

      nsmKo = nitro.blobs.${arch}.nsmKo;

      copyToRoot = rootfs;

      # Command with one argument per line
      entrypoint = "/bin/enclave";

      #
      # Provide git repo url and rev through environment to enable
      # verification of PCR0 via reproducible builds
      #
        
      # Environment variables, one per line
      env = ''
        GIT_URL=${gitUrl}
        GIT_REV=${gitRev}
      '';
    };

    # Build app as a Docker container image for `nitro-cli build-enclave`
    packages.x86_64-linux.docker = pkgs.dockerTools.buildImage {
      name = enclave.pname;
      tag = enclave.version;

      copyToRoot = rootfs;

      config = {
        Cmd = "/bin/enclave";
        Env = [
          "GIT_URL=${gitUrl}"
          "GIT_REV=${gitRev}"
        ];
      };
    };
  };
}
