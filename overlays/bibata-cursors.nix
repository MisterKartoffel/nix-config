_: _final: prev: {
  bibata-cursors = prev.bibata-cursors.overrideAttrs (_: {
    buildPhase = ''
      runHook preBuild

      ctgen configs/normal/x.build.toml -p x11 -d $bitmaps/Bibata-Modern-Ice -n 'Bibata-Modern-Ice' -c 'White and rounded edge Bibata XCursors'

      runHook postBuild
    '';
  });
}
