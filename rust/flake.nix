{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
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

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              rust-bin.stable.latest.default
              pre-commit
            ];
          };
        };
    };
}
