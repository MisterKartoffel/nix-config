{ config, lib, ... }:
let
  inherit (config.modules.services) sops;
  inherit (config.modules) system secrets;
  inherit (config.system.etc) overlay;
in
{
  system.etc.overlay = {
    enable = true;
    mutable = false;
  };

  # nixos-init: incompatibilities with both NixOS and Home Manager modules
  # https://github.com/nix-community/impermanence/issues/327
  system.nixos-init.enable = false;

  # GitHub issue workarounds:
  environment.etc = lib.mkIf (overlay.enable && !overlay.mutable) {
    # system.etc.overlay doesn't create /etc/NIXOS file
    # https://github.com/NixOS/nixpkgs/issues/341453
    "NIXOS".text = "";

    # nixos/etc: no handling of /etc/machine-id with readonly /etc
    # https://github.com/NixOS/nixpkgs/issues/523878
    "machine-id".text = system.machine-id;
  };

  # sops-nix fails copying SSH host key to /etc if it's immutable
  # fixed in modules/nixos/sops.nix

  # sshd daemon fails to start if key is not found
  # see issue above
  services.openssh.hostKeys = lib.optionals (sops.enable && overlay.enable && !overlay.mutable) [
    {
      path = secrets.host.ssh_key.path;
      type = "ed25519";
    }
  ];

}
