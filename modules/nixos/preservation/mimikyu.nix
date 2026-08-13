{ config, lib, ... }:
let
  inherit (config.services.gnome) gnome-keyring;
in
{
  preservation.preserveAt."/persist".users.mimikyu = {
    commonMountOptions = [
      "x-gvfs-hide"
      "x-gdu.hide"
    ];

    directories = [
      "Desktop"
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Projects"
      "Public"
      "Templates"
      "Videos"

      ".config/legcord"
      ".config/zen"
      ".cache/direnv/layouts"
      ".cache/nix"
    ]
    ++ lib.optionals gnome-keyring.enable [
      {
        directory = ".local/share/keyrings";
        mode = "0700";
      }
    ];

    files = [
      ".local/share/fish/fish_history"
    ];
  };
}
