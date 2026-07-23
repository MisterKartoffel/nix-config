{ pkgs, ... }:
{
  packages = builtins.attrValues { inherit (pkgs) oama; };

  xdg.config.files."oama/config.yaml" = {
    generator = (pkgs.formats.yaml { }).generate "config.yaml";

    value = {
      encryption.tag = "KEYRING";
      services.microsoft.client_id = "9e5f94bc-e8a4-4e73-b8be-63364c29d753";
    };
  };
}
