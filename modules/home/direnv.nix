{
  programs.direnv = {
    nix-direnv.enable = true;

    config = {
      global = {
        strict_env = true;
        warn_timeout = "1m";
        hide_env_diff = true;
      };

      whitelist.exact = map (project: "/home/mimikyu/Projects/${project}") [
        "nix-config"
        "nix-secrets"
      ];
    };
  };
}
