{
  config,
  lib,
  ...
}:
let
  inherit (config.programs) ssh;
in
{
  config = lib.mkIf ssh.enable {
    programs.ssh = {
      enableDefaultConfig = false;

      settings = {
        "*" = {
          AddKeysToAgent = "yes";
          IdentitiesOnly = true;
          IdentityFile = "~/.ssh/id_ed25519";
        };

        "kindle" = {
          HostName = "192.168.0.202";
          SetEnv.TERM = "linux";
        };
      };
    };

    services.ssh-agent.enable = true;
  };
}
