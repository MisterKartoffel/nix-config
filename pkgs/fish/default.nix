{
  wrapFish,
  fishPlugins,

  direnv,
  eza,
  fd,
  fzf,

  confDirs ? [ ./config ],
  pluginPkgs ? import ./plugins.nix { inherit fishPlugins; },
  shellAliases ? import ./aliases.nix,
  runtimeInputs ? [ direnv eza fd fzf ],
}:
wrapFish {
  inherit
    confDirs
    pluginPkgs
    shellAliases
    runtimeInputs
    ;
}
