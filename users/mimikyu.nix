{
  inputs,
  self,
  pkgs,
  ...
}:
{
  packages = builtins.attrValues {
    inherit (pkgs) legcord wl-clipboard zathura;
    inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) nvim zen-browser fish;
    inherit (inputs.ortie.packages.${pkgs.stdenv.hostPlatform.system}) default;
  };
}
