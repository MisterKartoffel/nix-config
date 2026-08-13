{ config, pkgs, ... }: {
  packages = builtins.attrValues { inherit (pkgs) direnv nix-direnv; };

  xdg.config.files."direnv/direnv.toml" = {
    generator = (pkgs.formats.toml { }).generate "direnv.toml";

    value = {
      global = {
        hide_env_diff = true;
        strict_env = true;
        warn_timeout = "1m";
      };

      whitelist.exact = map (project: "${config.directory}/Projects/${project}") [
        "nix-config"
        "nix-secrets"
      ];
    };
  };

  xdg.config.files."direnv/lib/nix-direnv.sh".source = "${pkgs.nix-direnv}/share/nix-direnv/direnvrc";
}
