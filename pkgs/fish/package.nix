#
{
  wrapFish,
  fishPlugins,

  direnv,
  eza,
  fd,
  fzf,

  completionDirs ? [ "/run/current-system/sw/share/fish/vendor_completions.d/" ],
  functionDirs ? [ "/run/current-system/sw/share/fish/vendor_functions.d/" ],
  confDirs ? [ "/run/current-system/sw/share/fish/vendor_conf.d/" ] ++ [ ./config ],
  pluginPkgs ? import ./plugins.nix { inherit fishPlugins; },
  shellAliases ? import ./aliases.nix,
  runtimeInputs ? [
    direnv
    eza
    fd
    fzf
  ],
}:
wrapFish {
  inherit
    completionDirs
    functionDirs
    confDirs
    pluginPkgs
    shellAliases
    runtimeInputs
    ;
}
