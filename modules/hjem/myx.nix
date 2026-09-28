{ osConfig, pkgs, ... }:
{
  packages = builtins.attrValues { inherit (pkgs) myx; };

  xdg.config.files."myx/config.toml".source = osConfig.sops.templates."myx-config.toml".path;
}
