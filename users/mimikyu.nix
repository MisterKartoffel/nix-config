{ self, pkgs, ... }:
{
  packages = builtins.attrValues {
    inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) nvim zen-browser;
    inherit (pkgs)
      # keep-sorted start

      legcord
      wl-clipboard
      zathura

      # keep-sorted end
      ;
  };
}
