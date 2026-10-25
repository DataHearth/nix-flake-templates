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
        { pkgs, lib, ... }:
        {
          devshells.default = {
            commands = [
              { package = pkgs.python3; }
              { package = pkgs.uv; }
              { package = pkgs.ruff; }
            ];

            env = [
              {
                name = "UV_PYTHON_DOWNLOADS";
                value = "never";
              }
              {
                name = "UV_PYTHON";
                value = pkgs.python3.interpreter;
              }
              {
                name = "PYTHONPATH";
                unset = true;
              }
            ]
            ++ lib.optional pkgs.stdenv.hostPlatform.isLinux {
              name = "LD_LIBRARY_PATH";
              value = lib.makeLibraryPath pkgs.pythonManylinuxPackages.manylinux1;
            };
          };
        };
    };
}
