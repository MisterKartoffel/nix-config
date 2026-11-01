{
  fetchurl,
  lib,
  makeBinaryWrapper,
  nushell,
  path,
  stdenvNoCC,
}:
let
  theme = import ./theme.nix { inherit fetchurl; };
in
stdenvNoCC.mkDerivation {
  inherit (nushell) name meta passthru;
  src = ./config;
  nativeBuildInputs = [ makeBinaryWrapper ];
  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share $out/bin
    cp -r --no-preserve=mode $src $out/share/nushell

    ln -sf ${theme} $out/share/nushell/autoload/${theme.name}

    substituteInPlace $out/share/nushell/modules/command-not-found.nu \
      --replace-fail "@dbPath@" "${path + "/programs.sqlite"}"

    makeBinaryWrapper ${lib.getExe nushell} $out/bin/nu \
      --inherit-argv0 \
      --add-flags "--config-home $out/share/nushell"
  '';
}
