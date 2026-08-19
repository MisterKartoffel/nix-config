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
  xdg.config.files."neomutt/send-hook/hotmail".text = /* muttrc */ ''
    set real_name = "Felipe Duarte"

    set smtp_url = "smtp://smtp.office365.com/"
    set smtp_user = "felipesdrs@hotmail.com"
    set smtp_authenticators = "xoauth2"
    set smtp_oauth_refresh_command = "${lib.getExe ortie} token show --account hotmail"

    set record = +Sent
  '';
}
