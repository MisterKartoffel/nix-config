{ config, lib, ... }:
let
  ssh = config.services.openssh;
in
{
  preservation.preserveAt."/persist" = {
    directories = [
      "/etc/nixos"
      "/var/lib/systemd/timers"
      "/var/lib/systemd/rfkill"
      "/var/lib/systemd/coredump"
      "/var/log"
      {
        directory = "/var/lib/nixos";
        inInitrd = true;
      }
    ];

    files = [
      {
        file = "/etc/machine-id";
        how = "symlink";
        inInitrd = true;
        configureParent = true;
      }
      {
        file = "/var/lib/systemd/random-seed";
        how = "symlink";
        inInitrd = true;
        configureParent = true;
      }
    ]
    ++ lib.optionals ssh.enable [
      {
        file = "/etc/ssh/ssh_host_ed25519_key";
        how = "symlink";
        configureParent = true;
      }
    ];

    users.mimikyu = {
      commonMountOptions = [
        "x-gvfs-hide"
        "x-gdu.hide"
      ];

      directories = [
        "Desktop"
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Projects"
        "Public"
        "Templates"
        "Videos"
      ];

      files = lib.optionals ssh.enable [
        {
          file = ".ssh/known_hosts";
          configureParent = true;
          parent.mode = "0700";
        }
      ];
    };
  };
}
