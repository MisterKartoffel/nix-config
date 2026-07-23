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
      ".cache/nix"
      "Desktop"
      "Documents"
      "Downloads"
      "Mail"
      "Music"
      "Pictures"
      "Projects"
      "Public"
      "Templates"
      "Videos"

      ".local/share/offlineimap"
      ".config/vesktop"
      ".config/zen"
    ]
    ++ lib.optionals gnome-keyring.enable [
      {
        directory = ".local/share/keyrings";
        mode = "0700";
      }
    ];

    files = [
      ".config/zsh/.p10k.zsh"
      ".local/state/zsh/history"
    ];
  };
}
