{
  fetchurl,
  lib,
  nushell,
  symlinkJoin,
  writeShellApplication,

  configDirs ? [ ./config ],
}:
let
  theme = import ./theme.nix { inherit fetchurl; };
  configHome = symlinkJoin {
    name = "nu-config-home";
    paths = configDirs;
    postBuild = ''
      ln -s ${theme} $out/autoload/${theme.name}
    '';
  };
in
writeShellApplication {
  inherit (nushell) name passthru;
  text = ''
    exec ${lib.getExe nushell} --config-home ${configHome} "$@"
  '';
}
