{ pkgs, lib, ... }:
{
  xdg.config.files."neomutt/account-hook/ufrgs".text = /* muttrc */ ''
    set folder = "imaps://imap.ufrgs.br/"
    set imap_user = "00288910@ufrgs.br"
    set imap_authenticators = "login"
    set imap_pass = `${lib.getExe pkgs.oo7} lookup application=neomutt email=00288910@ufrgs.br --secret-only`
  '';
}
