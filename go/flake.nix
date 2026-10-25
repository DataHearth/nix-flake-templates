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
        { pkgs, self', ... }:
        {
          packages.default = pkgs.buildGoLatestModule {
            pname = "my-module";
            version = "0.1.0";
            src = ./.;
            vendorHash = null;
          };

          checks = {
            build = self'.packages.default;
            lint = pkgs.runCommandLocal "check-golangci-lint" {
              nativeBuildInputs = with pkgs; [
                go_latest
                golangci-lint
              ];
            } ''
              export HOME=$TMPDIR
              export GOPATH=$TMPDIR/go
              export GOCACHE=$TMPDIR/go-cache
              cp -r ${./.} src
              chmod -R u+w src
              cd src
              golangci-lint run
              touch $out
            '';
          };

          devshells.default.commands = [
            { package = pkgs.go_latest; }
            { package = pkgs.golangci-lint; }
            {
              name = "lint";
              help = "run golangci-lint";
              command = "golangci-lint run";
            }
          ];
        };
    };
}
