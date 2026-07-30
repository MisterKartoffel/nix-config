{ pkgs, lib, ... }: {
  settings = {
    global.tree-root-file = "flake.nix";

    formatter = {
      nix = {
        command = lib.getExe pkgs.nixfmt;
        includes = [ "*.nix" ];
      };

      lua = {
        command = lib.getExe pkgs.stylua;
        includes = [ "*.lua" ];
      };
    };
  };
}
