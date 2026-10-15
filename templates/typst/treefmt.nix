{ pkgs, lib }:
{
  settings = {
    tree-root-file = "flake.nix";

    formatter = {
      typstyle = {
        command = lib.getExe pkgs.typstyle;
        includes = [ "*.typ" ];
      };

      keep-sorted = {
        command = lib.getExe pkgs.keep-sorted;
        includes = [ "*" ];
      };
    };
  };
}
