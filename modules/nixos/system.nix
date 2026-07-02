{ config, lib, ... }:
let
  inherit (config.system.etc) overlay;
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
}
