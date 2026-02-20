{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      perSystem =
        { pkgs, ... }:
        {
          checks.lint = pkgs.runCommandLocal "check-biome" {
            nativeBuildInputs = [ pkgs.biome ];
          } ''
            cd ${./.}
            biome lint .
            touch $out
          '';

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              nodejs
              pnpm
              biome
              pre-commit
            ];
          };
        };
    };
}
