{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = false;
    packages = builtins.attrValues {
      inherit (pkgs.nerd-fonts) commit-mono;
      inherit (pkgs)
        freefont_ttf
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
        ;
    };
  };

  fonts.fontconfig = {
    subpixel.rgba = "rgb";
    defaultFonts = {
      serif = [ "FreeSerif" ];
      sansSerif = [ "FreeSans" ];
      monospace = [ "Commit Mono Nerd Font" ];
      emoji = [ "Noto Fonts Color Emoji" ];
    };
  };
}
