{ pkgs, ... }: {
  xdg.config.files."ortie/config.toml" = {
    generator = (pkgs.formats.toml { }).generate "ortie-config.toml";

    value = {
      accounts.hotmail = {
        default = true;
        auto-refresh = true;
        client-id = "9e5f94bc-e8a4-4e73-b8be-63364c29d753";
        grant = "device";

        endpoints = {
          device-authorization = "https://login.microsoftonline.com/common/oauth2/v2.0/devicecode";
          token = "https://login.microsoftonline.com/common/oauth2/v2.0/token";
          redirection = "https://localhost";
        };

        scopes = [
          "https://outlook.office.com/IMAP.AccessAsUser.All"
          "https://outlook.office.com/SMTP.Send"
          "offline_access"
        ];
        storage = {
          read.command = [
            "oo7-cli"
            "lookup"
            "application=ortie"
            "email=felipesdrs@hotmail.com"
            "--secret-only"
          ];
          write.command = [
            "oo7-cli"
            "store"
            "Hotmail OAUTH2 token"
            "application=ortie"
            "email=felipesdrs@hotmail.com"
          ];
        };
      };
    };
  };
}
