{
  osConfig,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (osConfig.services) openssh;
in
{
  config = mkIf openssh.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks = {
        "*" = {
          host = "*";
          addKeysToAgent = "yes";
          identitiesOnly = true;
          identityFile = "~/.ssh/id_ed25519";
        };

        "kindle" = {
          host = "kindle";
          hostname = "192.168.0.202";
          setEnv."TERM" = "linux";
        };
      };
    };

    services.ssh-agent.enable = true;
  };
}
