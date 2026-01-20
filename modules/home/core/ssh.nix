{
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

      "github" = {
        host = "github";
        hostname = "github.com";
        user = "git";
      };

      "kindle" = {
        host = "kindle";
        hostname = "192.168.0.202";
        setEnv."TERM" = "linux";
      };
    };
  };

  services.ssh-agent = {
    enable = true;
    enableZshIntegration = true;
  };
}
