{ repoRoot, inputs, pkgs, system, lib }:
let
  rust-project = {
    packages = repoRoot.nix.rust-project;
    devShells = {
      default = repoRoot.nix.rust-project.devShell;
    };
  };

in
[
  (rust-project)
]
