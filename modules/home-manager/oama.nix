{
  config,
  pkgs,
  lib,
  ...
}:
let
  yamlFormat = pkgs.formats.yaml { };

  cfg = config.programs.neomutt;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = builtins.attrValues {
      inherit (pkgs)
        gnome-keyring
        gcr
        libsecret
        oama
        ;
    };

    services.gnome-keyring.enable = true;

    xdg.configFile."oama/config.yaml".source = yamlFormat.generate "config.yaml" {
      encryption.tag = "KEYRING";
      services.microsoft.client_id = "9e5f94bc-e8a4-4e73-b8be-63364c29d753";
    };
  };
}
