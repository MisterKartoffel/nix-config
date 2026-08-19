{ pkgs, lib, ... }:
{
  xdg.config.files."neomutt/send-hook/ufrgs".text = /* muttrc */ ''
    set real_name = "Felipe Duarte"

    set smtp_url = "smtp://smtp.ufrgs.br/"
    set smtp_user = "00288910@ufrgs.br"
    set smtp_authenticators = "plain"
    set smtp_pass = `${lib.getExe pkgs.oo7} lookup application=neomutt email=00288910@ufrgs.br --secret-only`

    set record = +Sent
  '';
}
