{ self, pkgs, ... }: {
  packages = builtins.attrValues {
    inherit (pkgs) wl-clipboard zathura;
    inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) nvim zen-browser;
  };
}
