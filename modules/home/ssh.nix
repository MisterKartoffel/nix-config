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

      matchBlocks = {
        "*" = {
          addKeysToAgent = "yes";
          identitiesOnly = true;
          identityFile = "~/.ssh/id_ed25519";
        };

        "kindle" = {
          hostname = "192.168.0.202";
          setEnv."TERM" = "linux";
        };
      };
    };

    services.ssh-agent.enable = true;
  };
}
