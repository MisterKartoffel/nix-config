{ pkgs, lib, ... }:
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

      include = pkgs.fetchurl {
        name = "tofi-colors.conf";
        url = "https://raw.githubusercontent.com/catppuccin/tofi/refs/heads/main/themes/catppuccin-mocha";
        hash = "sha256-epKCz6gAHq3euR80UkGRuSu+l0xaSZc8zKzUjSuUf0Y=";
      };
    };
  };
}
