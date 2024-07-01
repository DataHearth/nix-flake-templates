{
  description = "Collection of flake templates";

  outputs = { self }: {
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
      node = {
        path = ./node;
        description = "Basic NodeJS template";
      };
      sveltekit = {
        path = ./sveltekit;
        description =
          "SvelteKit template with Typescript support and tooling enabled";
      };
    };
  };
}
