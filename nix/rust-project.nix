{ repoRoot, inputs, pkgs, lib, system }:

let
  toolchain = with inputs.fenix.packages.${system}; {
    rustc = latest.rustc;
    cargo = latest.cargo;
  };

  naersk' = pkgs.callPackage inputs.naersk {
    cargo = toolchain.cargo;
    rustc = toolchain.rustc;
  };

  cargoProject = naersk'.buildPackage {
    src = ../.;
    nativeBuildInputs = with pkgs; [ m4 pkg-config ];
    release = true;
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };

  devShell = pkgs.mkShell {
    buildInputs = [
      toolchain.rustc
      toolchain.cargo
      pkgs.pkg-config
      pkgs.openssl
    ];
  };

  outputs = {
    inherit devShell;
    my-rust-project = cargoProject // {
      meta = {
        type = "app";
      };
    };
  };

in

outputs
