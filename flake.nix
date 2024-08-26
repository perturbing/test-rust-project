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
          rustc = stable.rustc;
          cargo = stable.cargo;
          cbindgen = pkgs.rust-cbindgen;
        };

        naersk' = pkgs.callPackage naersk {};

        cargoProject = naersk'.buildPackage {
          src = ./rust_to_c;
          release = true;
          nativeBuildInputs = [ toolchain.cbindgen ];
          installPhase = ''
            mkdir -p $out/lib
            # cbindgen --crate rust_to_c --output $out/include/rust_to_c.h --lang c

            cp target/release/lib*.so $out/lib/ || true
            cp target/release/lib*.dylib $out/lib/ || true
            cp target/release/lib*.dll $out/lib/ || true


            mkdir -p $out/include
            cat > $out/include/rust_to_c.h <<'EOF'
            #include "blst.h"

            // Define the Scalar structure as it is in Rust
            typedef struct {
              blst_fr inner;
            } Scalar;

            // Function prototype
            void random_scalar(Scalar *a);
            EOF
              '';
        };

        cLibrary = pkgs.stdenv.mkDerivation {
          name = "librust_to_c";
          version = "1.0";
          src = cargoProject;

          buildInputs = [ pkgs.pkg-config ];

          installPhase = ''
            mkdir -p $out/lib
            if [ -f $src/lib/librust_to_c.so ]; then
              cp $src/lib/librust_to_c.so $out/lib/
            fi
            if [ -f $src/lib/librust_to_c.dylib ]; then
              cp $src/lib/librust_to_c.dylib $out/lib/
            fi
            if [ -f $src/lib/librust_to_c.dll ]; then
              cp $src/lib/librust_to_c.dll $out/lib/
            fi
            mkdir -p $out/include
            cp $src/include/rust_to_c.h $out/include/

            # Adding pkg-config support
            mkdir -p $out/lib/pkgconfig
            cat <<EOF > $out/lib/pkgconfig/librust_to_c.pc
            prefix=$out
            exec_prefix=''\\''${prefix}
            libdir=''\\''${exec_prefix}/lib
            includedir=''\\''${prefix}/include

            Name: librust_to_c
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
