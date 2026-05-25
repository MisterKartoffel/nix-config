{
  osConfig,
  config,
  lib,
  ...
}:
let
  inherit (config.xdg) userDirs;
  inherit (config.accounts.email) maildirBasePath;
  inherit (config.services) gnome-keyring;
  inherit (config.programs)
    offlineimap
    vesktop
    zen-browser
    zsh
    ;

  inherit (osConfig.modules.services) impermanence;
in
{
  home.persistence.${impermanence.path} = {
    enable = lib.mkDefault impermanence.enable;
    hideMounts = true;

    directories =
      lib.optionals (userDirs.enable && userDirs.createDirectories) (
        map baseNameOf (
          builtins.filter (path: path != null) (
            builtins.attrValues {
              inherit (userDirs)
                desktop
                documents
                download
                music
                pictures
                projects
                publicShare
                templates
                videos
                ;
            }
          )
        )
      )
      ++ lib.optionals offlineimap.enable [
        (baseNameOf maildirBasePath)
      ]
      ++ lib.optionals vesktop.enable [
        ".config/vesktop"
      ]
      ++ lib.optionals zen-browser.enable [
        ".config/zen"
      ]
      ++ lib.optionals gnome-keyring.enable [
        {
          directory = ".local/share/keyrings";
          mode = "0700";
        }
      ];

    files = lib.optionals zsh.enable [
      ".config/zsh/.p10k.zsh"
      ".local/state/zsh/history"
    ];
  };
}
