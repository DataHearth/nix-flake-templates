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
    };
  };
}
