{ config, lib, ... }:
let
  inherit (config.services) oo7;
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
      ".cache/myx"
      ".cache/neomutt"
      ".cache/nix"
    ]
    ++ lib.optionals oo7.enable [
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
