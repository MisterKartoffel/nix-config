{ pkgs, ... }: {
  packages = builtins.attrValues { inherit (pkgs) impala; };

  xdg.config.files."impala/config.toml" = {
    generator = (pkgs.formats.toml { }).generate "impala-config.toml";

    value = {
      esc_quit = true;
    };
  };
}
