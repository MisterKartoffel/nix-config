{ config, lib, ... }:
let
  ssh = config.services.openssh;
in
{
  environment.persistence."/etc/persist" = {
    hideMounts = true;

    directories = [
      "/var/lib/nixos"
      "/var/lib/systemd/timers"
      "/var/lib/systemd/rfkill"
      "/var/lib/systemd/coredump"
      "/var/log"
      {
        directory = "/etc/nixos";
        user = "mimikyu";
        group = "users";
      }
    ];

    files = [
      "/etc/machine-id"
      "/var/lib/sops-nix/key.txt"
    ]
    ++ lib.optionals ssh.enable [
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };
}
