{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  ortie = inputs.ortie.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  xdg.config.files."himalaya/config.toml" = {
    enable = false;
    generator = (pkgs.formats.toml { }).generate "himalaya-config.toml";

    value = {
      accounts.hotmail =
        let
          sasl.xoauth2 = {
            username = "felipesdrs@hotmail.com";
            token.command = [
              (lib.getExe ortie)
              "token"
              "show"
              "--account"
              "hotmail"
            ];
          };
        in
        {
          imap = {
            server = "imaps://outlook.office365.com/";
            inherit sasl;
          };
          smtp = {
            server = "smtp://smtp.office365.com/";
            starttls = true;
            inherit sasl;
          };
        };
    };
  };
}
