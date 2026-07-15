{
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
}
