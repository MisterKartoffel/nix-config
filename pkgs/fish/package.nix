#
{
  wrapFish,
  fishPlugins,

  direnv,
  eza,
  fd,
  fzf,

  completionDirs ? [ ],
  functionDirs ? [ ],
  confDirs ? [ ./config ],
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
