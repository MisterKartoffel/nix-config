{
  pkgs,
  lib,
  secrets,
  service,
  overrides ? { },
}:
{
  ${service} = rec {
    enable = true;

    address = secrets.${service}.email;
    userName = address;
    realName = secrets.name;

    neomutt.enable = true;

    offlineimap = {
      enable = true;
      extraConfig.remote = {
        auth_mechanisms = lib.toUpper (overrides.imap.authentication or "plain");
        createfolders = false;
      };
    };

    imapnotify = {
      enable = true;
      extraConfig = {
        onNewMail = "${lib.getExe pkgs.offlineimap} -a ${service}";
        onNewMailPost = "${pkgs.libnotify}/bin/notify-send '[${service}] New mail!'";
      };
    };

    msmtp.enable = true;
  };
}
