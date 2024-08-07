{
  description = "Flake example for building Rust and C libraries";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    naersk.url = "github:nix-community/naersk";
    fenix.url = "github:nix-community/fenix";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, naersk, fenix, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        toolchain = with fenix.packages.${system}; {
          rustc = latest.rustc;
          cargo = latest.cargo;
          cbindgen = pkgs.rust-cbindgen;
        };

        naersk' = pkgs.callPackage naersk {};

        cargoProject = naersk'.buildPackage {
          src = ./rust_to_c;
          release = true;
          nativeBuildInputs = [ toolchain.cbindgen ];
          installPhase = ''
            mkdir -p $out/lib
            cbindgen --crate rust_to_c --output $out/include/libmyrust.h
            cp target/release/librust_to_c.so $out/lib/libmyrust.so || true
            cp target/release/librust_to_c.dylib $out/lib/libmyrust.dylib || true
            cp target/release/librust_to_c.dll $out/lib/libmyrust.dll || true
          '';
        };

        cLibrary = pkgs.stdenv.mkDerivation {
          name = "libmyrust";
          version = "1.0";
          src = cargoProject;

          buildInputs = [ pkgs.pkg-config ];

          installPhase = ''
            mkdir -p $out/lib
            if [ -f $src/lib/libmyrust.so ]; then
              cp $src/lib/libmyrust.so $out/lib/
            fi
            if [ -f $src/lib/libmyrust.dylib ]; then
              cp $src/lib/libmyrust.dylib $out/lib/
            fi
            if [ -f $src/lib/libmyrust.dll ]; then
              cp $src/lib/libmyrust.dll $out/lib/
            fi
            mkdir -p $out/include
            cp $src/include/libmyrust.h $out/include/

            # Adding pkg-config support
            mkdir -p $out/lib/pkgconfig
            cat <<EOF > $out/lib/pkgconfig/libmyrust.pc
            prefix=$out
            exec_prefix=''\\''${prefix}
            libdir=''\\''${exec_prefix}/lib
            includedir=''\\''${prefix}/include

            Name: libmyrust
            Description: Library generated from Rust code
            Version: 1.0

            Cflags: -I''\\''${includedir}
            Libs: -L''\\''${libdir} -lrust_to_c
            EOF
          '';
        };

      in rec {
        defaultPackage = cLibrary;

        devShell = pkgs.mkShell {
          buildInputs = [
            toolchain.rustc
            toolchain.cargo
            pkgs.rust-cbindgen
          ];
        };
      }
    );
}
