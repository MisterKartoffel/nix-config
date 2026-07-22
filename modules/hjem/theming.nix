{ inputs, pkgs, ... }: {
  xdg.config.files = {
    "gtk-2.0".source = "${
      inputs.basix.themePackages.${pkgs.stdenv.hostPlatform.system}.base24.catppuccin-mocha
    }/share/themes/Basix-catppuccin-mocha/gtk-2.0";

    "gtk-3.0".source = "${
      inputs.basix.themePackages.${pkgs.stdenv.hostPlatform.system}.base24.catppuccin-mocha
    }/share/themes/Basix-catppuccin-mocha/gtk-3.0";

    "gtk-4.0".source = "${
      inputs.basix.themePackages.${pkgs.stdenv.hostPlatform.system}.base24.catppuccin-mocha
    }/share/themes/Basix-catppuccin-mocha/gtk-4.0";

    "Kvantum".source = "${
      inputs.basix.themePackages.${pkgs.stdenv.hostPlatform.system}.base24.catppuccin-mocha
    }/share/Kvantum/Basix-catppuccin-mocha";
  };
}
