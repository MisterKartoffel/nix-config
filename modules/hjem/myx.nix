{ inputs, osConfig, pkgs, ... }:
let
  inherit (inputs.myx.packages.${pkgs.stdenv.hostPlatform.system}) myx;
in {
  packages = builtins.attrValues { inherit myx; };

  xdg.config.files."myx/config.toml".source = osConfig.sops.templates."myx-config.toml".path;
}
