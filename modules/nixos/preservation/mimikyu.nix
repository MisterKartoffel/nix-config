{ config, lib, ... }:
let
  inherit (config.services) oo7;
in
{
  preservation.preserveAt."/persist".users.mimikyu = {
    commonMountOptions = [
      "x-gdu.hide"
      "x-gvfs-hide"
    ];

    directories = [
      # keep-sorted start

      ".cache/direnv/layouts"
      ".cache/myx"
      ".cache/neomutt"
      ".cache/nix"
      ".config/legcord"
      ".config/zen"
      "Desktop"
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Projects"
      "Public"
      "Templates"
      "Videos"

      # keep-sorted end
    ]
    ++ lib.optionals oo7.enable [
      {
        directory = ".local/share/keyrings";
        mode = "0700";
      }
    ];

    files = [
      ".local/share/fish/fish_history"
      {
        /*
          This will be here until nh can read tokens from nix.conf:
          https://github.com/nix-community/nh/issues/720
        */
        file = ".local/state/nh/github-token";
        mode = "0600";
      }
    ];
  };
}
