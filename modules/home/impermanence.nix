{
  osConfig,
  config,
  lib,
  ...
}:
let
  inherit (config.xdg) userDirs;
  inherit (config.accounts.email) maildirBasePath;
  inherit (config.programs)
    offlineimap
    vesktop
    zen-browser
    zsh
    ;

  inherit (osConfig.modules.services) impermanence;

  gnome-keyring.enable = lib.any (service: service.enable) [
    osConfig.services.gnome.gnome-keyring
    config.services.gnome-keyring
  ];
in
{
  home.persistence.${impermanence.path} = {
    inherit (impermanence) enable;
    hideMounts = true;

    directories = [
      ".cache/nix"
    ]
    ++ lib.optionals (userDirs.enable && userDirs.createDirectories) (
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
    ++ lib.optionals gnome-keyring.enable [
      {
        directory = ".local/share/keyrings";
        mode = "0700";
      }
    ]
    ++ lib.optionals offlineimap.enable [
      (baseNameOf maildirBasePath)
      ".local/share/offlineimap"
    ]
    ++ lib.optionals vesktop.enable [
      ".config/vesktop"
    ]
    ++ lib.optionals zen-browser.enable [
      ".config/zen"
    ];

    files = lib.optionals zsh.enable [
      ".config/zsh/.p10k.zsh"
      ".local/state/zsh/history"
    ];
  };
}
