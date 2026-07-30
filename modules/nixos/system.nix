{ config, lib, ... }:
let
  inherit (config.system.etc) overlay;
in
{
  system.etc.overlay = {
    enable = true;
    mutable = false;
  };

  system.nixos-init.enable = true;

  /*
    system.etc.overlay doesn't create /etc/NIXOS file
    https://github.com/NixOS/nixpkgs/issues/341453
  */
  environment.etc."NIXOS".text = lib.mkIf (overlay.enable && !overlay.mutable) "";
}
