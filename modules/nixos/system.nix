{ config, lib, ... }:
let
  inherit (config.modules.services) sops;
  inherit (config.system.etc) overlay;
  inherit (config.sops) secrets;
in
{
  system.etc.overlay = {
    enable = true;
    mutable = false;
  };

  # GitHub issue workarounds:

  # nixos-init: incompatibilities with both NixOS and Home Manager modules
  # https://github.com/nix-community/impermanence/issues/327
  system.nixos-init.enable = false;

  # system.etc.overlay doesn't create /etc/NIXOS file
  # https://github.com/NixOS/nixpkgs/issues/341453
  environment.etc."NIXOS".text = lib.mkIf (overlay.enable && !overlay.mutable) "";

  # sops-nix fails copying SSH host key to /etc if it's immutable
  # fixed in modules/nixos/sops.nix

  # sshd daemon fails to start if key is not found
  # see issue above
  services.openssh.hostKeys = lib.optionals sops.enable [
    {
      path = secrets."ssh_key".path;
      type = "ed25519";
    }
  ];

}
