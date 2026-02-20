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
        { pkgs, self', ... }:
        {
          packages.default = pkgs.buildGoModule {
            pname = "my-module";
            version = "0.1.0";
            src = ./.;
            vendorHash = null;
          };

          checks = {
            build = self'.packages.default;
            lint = pkgs.runCommandLocal "check-golangci-lint" {
              nativeBuildInputs = with pkgs; [
                go
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

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              go
              golangci-lint
              pre-commit
            ];
          };
        };
    };
}
