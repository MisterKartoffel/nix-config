{ pkgs, ... }: {
  runtimeInputs = builtins.attrValues { inherit (pkgs) nixfmt stylua; };

  settings = {
    global.tree-root-file = "flake.nix";

    formatter = {
      nix = {
        command = "nixfmt";
        includes = [ "*.nix" ];
      };

      lua = {
        command = "stylua";
        includes = [ "*.lua" ];
      };
    };
  };
}
