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
  xdg.config.files."neomutt/account-hook/hotmail".text = /* muttrc */ ''
    set folder = "imaps://outlook.office365.com/"
    set imap_user = "felipesdrs@hotmail.com"
    set imap_authenticators = "xoauth2"
    set imap_oauth_refresh_command = "${lib.getExe ortie} token show --account hotmail"

    set spool_file = +Inbox
  '';
}
