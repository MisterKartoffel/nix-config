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
  inherit (nushell) name version passthru;
  src = ./config;
  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/config/autoload
    cp -r . $out/share/config

    substituteInPlace $out/share/config/modules/command-not-found.nu \
      --replace-fail "@dbPath@" "${path + "/programs.sqlite"}"

    ln -sf ${theme} $out/share/config/autoload/${theme.name}

    mkdir -p $out/bin
    makeBinaryWrapper ${lib.getExe nushell} $out/bin/nu \
      --inherit-argv0 \
      --add-flags "--config-home $out/share/config"

    runHook postInstall
  '';
}
