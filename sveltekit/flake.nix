{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
        { pkgs, ... }:
        {
          checks.lint = pkgs.runCommandLocal "check-biome" {
            nativeBuildInputs = [ pkgs.biome ];
          } ''
            cd ${./.}
            biome lint .
            touch $out
          '';

          devshells.default.commands = [
            { package = pkgs.nodejs; }
            { package = pkgs.pnpm; }
            { package = pkgs.biome; }
          ];
        };
    };
}
