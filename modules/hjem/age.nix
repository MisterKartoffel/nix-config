{ osConfig, config, ... }: {
  xdg.config.files."sops/age/keys.txt".source = osConfig.sops.secrets."${config.user}/age_key".path;
}
