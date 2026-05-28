{
  pkgs,
  lib,
  secrets,
  service,
  overrides ? { },
}:
{
  ${service} = rec {
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

      onNotify = "${lib.getExe pkgs.offlineimap} -a ${service}";
      onNotifyPost = "${lib.getExe' pkgs.libnotify "notify-send"} '[${service}] New mail!'";

      extraArgs = [ "-log-level warn" ];
    };

    msmtp.enable = true;
  };
}
