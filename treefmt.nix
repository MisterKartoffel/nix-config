{ pkgs, lib, ... }: {
  settings = {
    tree-root-file = "flake.nix";

    formatter = {
      deadnix = {
        command = lib.getExe pkgs.deadnix;
        options = [ "--edit" ];
        includes = [ "*.nix" ];
        priority = 1;
      };

      statix = {
        command = lib.getExe pkgs.statix;
        options = [ "fix" ];
        includes = [ "*.nix" ];
        priority = 2;
        no-positional-arg-support = true;
      };

      nixfmt = {
        command = lib.getExe pkgs.nixfmt;
        includes = [ "*.nix" ];
        priority = 3;
      };

      stylua = {
        command = lib.getExe pkgs.stylua;
        includes = [ "*.lua" ];
      };
    };
  };
}
