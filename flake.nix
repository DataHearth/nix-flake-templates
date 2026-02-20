{
  description = "Collection of flake templates";

  outputs =
    { self }:
    {
      templates = {
        python = {
          path = ./python;
          description = "Basic python template";
        };
        rust = {
          path = ./rust;
          description = "Basic rust template";
        };
        go = {
          path = ./go;
          description = "Basic go template";
        };
        typescript = {
          path = ./typescript;
          description = "Basic TypeScript template with Biome";
        };
        sveltekit = {
          path = ./sveltekit;
          description = "SvelteKit template with Typescript support and tooling enabled";
        };
        basic = {
          path = ./basic;
          description = "A basic template with a nix-devenv";
        };
      };
    };
}
