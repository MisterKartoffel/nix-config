{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (inputs.basix.schemeData.base24.catppuccin-mocha) palette;
in
{
  packages = builtins.attrValues { inherit (pkgs) tofi; };

  xdg.config.files."tofi/config" = {
    generator = lib.generators.toKeyValue { };
    value = {
      font = "Commit Mono Nerd Font";
      font-size = "24";

      num-results = 5;
      result-spacing = 25;

      width = "100%";
      height = "100%";
      outline-width = 0;
      border-width = 0;
      padding-top = "35%";
      padding-left = "35%";

      hide-cursor = true;
      history = true;
      fuzzy-match = true;
      drun-launch = true;

      background-color = palette.base00;
      outline-color = palette.base05;
      border-color = palette.base05;
      text-color = palette.base05;
      prompt-color = palette.base0A;
      prompt-background = palette.base00;
      placeholder-color = palette.base03;
      input-background = palette.base00;
      default-result-background = palette.base00;
      selection-color = palette.base03;
      selection-background = palette.base00;
    };
  };
}
