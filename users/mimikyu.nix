{ self, pkgs, ... }:
{
  packages = builtins.attrValues {
    inherit (pkgs)
      impala
      legcord
      wl-clipboard
      zathura
      ;
    inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) nvim zen-browser fish;
  };
}
