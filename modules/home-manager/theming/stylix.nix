{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.stylix.homeModules.stylix ];

  fonts.fontconfig.enable = true;

  stylix = {
    enable = true;

    targets = {
      nvf.enable = false;
      zen-browser.profileNames = [ "Profile0" ];
    };

    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.commit-mono;
        name = "Commit Mono Nerd Font";
      };
      sizes.terminal = 16;
    };
  };
}
