{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}:
let
  yamlFormat = pkgs.formats.yaml { };
  inherit (config.accounts.email.accounts) hotmail;
in
{
  config = lib.mkIf (hotmail.enable && hotmail.offlineimap.enable) (
    {
      xdg.configFile."oama/config.yaml".source = yamlFormat.generate "config.yaml" {
        encryption.tag = "KEYRING";
        services.microsoft.client_id = hotmail.offlineimap.extraConfig.remote.oauth2_client_id;
      };
    }
    // lib.optionalAttrs (!osConfig.services.gnome.gnome-keyring.enable) {
      services.gnome-keyring.enable = true;

      home.packages = builtins.attrValues {
        inherit (pkgs)
          gnome-keyring
          gcr
          libsecret
          ;
      };
    }
  );
}
