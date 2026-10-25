{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.devshell.flakeModule ];
      systems = [ "x86_64-linux" ];
      perSystem =
        { pkgs, system, ... }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [ (import inputs.rust-overlay) ];
          };

          # Uncomment once Cargo.lock is tracked by git:
          # packages.default = pkgs.rustPlatform.buildRustPackage {
          #   pname = "package_name";
          #   version = "0.1.0";
          #   src = ./.;
          #   cargoHash = "";
          # };

          checks.fmt = pkgs.runCommandLocal "check-rust-fmt" {
            nativeBuildInputs = [ pkgs.rust-bin.stable.latest.default ];
          } ''
            cd ${./.}
            cargo fmt --check
            touch $out
          '';

          devshells.default.commands = [
            {
              name = "cargo";
              help = "Rust stable toolchain";
              package = pkgs.rust-bin.stable.latest.default;
            }
            {
              name = "lint";
              help = "run cargo clippy";
              command = "cargo clippy --all-targets -- -D warnings";
            }
          ];
        };
    };
}
