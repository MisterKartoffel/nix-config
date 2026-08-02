{ osConfig, ... }:
let
  inherit (osConfig.services) openssh;
in
{
  files.".ssh/config" = {
    inherit (openssh) enable;
    text = /* ssh_config */ ''
      Host *
        AddKeysToAgent yes
        IdentitiesOnly yes
        IdentityFile ~/.ssh/id_ed25519

      Host kindle
        HostName 192.168.0.202
        SetEnv TERM=linux
    '';
  };
}
