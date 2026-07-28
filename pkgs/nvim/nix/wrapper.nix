{
  stdenv,
  lib,
  neovim-unwrapped,
  wrapNeovimUnstable,
}:
{
  appName ? "nvim",
  plugins ? [ ],
  treesitter ? [ ],
  extraPackages ? [ ],
  ignoreConfigRegexes ? [ ],
  extraLuaPackages ? _: [ ],
  extraPython3Packages ? _: [ ],
  withPython3 ? false,
  withRuby ? false,
  withNodeJs ? false,
  viAlias ? appName == "nvim",
  vimAlias ? appName == "nvim",
  initLuaPre ? "",
  wrapRc ? true,
}:
let
  customAppName = appName != "nvim" && appName != null && appName != "";

  defaultPlugin = {
    plugin = null;
    config = null;
    optional = false;
  };

  normalizedPlugins =
    map (x: defaultPlugin // (if x ? plugin then x else { plugin = x; })) plugins ++ treesitter;

  nvimRtpSrc =
    let
      src = ../.;
    in
    lib.cleanSourceWith {
      inherit src;
      name = "nvim-rtp-src";
      filter =
        path: _:
        let
          srcPrefix = toString src + "/";
          relPath = lib.removePrefix srcPrefix (toString path);
        in
        builtins.all (regex: builtins.match regex relPath == null) ignoreConfigRegexes;
    };

  nvimRtp = stdenv.mkDerivation {
    name = "nvim-rtp";
    src = nvimRtpSrc;

    buildPhase = ''
      mkdir -p $out/nvim
      mkdir -p $out/lua
      rm -r nix
      rm init.lua default.nix
    '';

    installPhase = ''
      cp -r lua $out/lua
      rm -r lua

      if [ -d "after" ]; then
        cp -r after $out/after
        rm -r after
      fi

      if [ ! -z "$(ls -A)" ]; then
        cp -r -- * $out/nvim
      fi
    '';
  };

  initLua =
    initLuaPre
    + ""
    + ''
      vim.opt.rtp:prepend("${nvimRtp}/lua")
    ''
    + ""
    + (builtins.readFile ../init.lua)
    + ""
    + ''
      vim.opt.rtp:prepend("${nvimRtp}/nvim")
      vim.opt.rtp:prepend("${nvimRtp}/after")
    '';

  extraMakeWrapperArgs = builtins.concatStringsSep " " (
    (lib.optional customAppName ''--set NVIM_APPNAME "${appName}"'')
    ++ (lib.optional (extraPackages != [ ]) ''--prefix PATH : "${lib.makeBinPath extraPackages}"'')
  );

  luaPackages = neovim-unwrapped.lua.pkgs;
  resolvedExtraLuaPackages = extraLuaPackages luaPackages;

  extraMakeWrapperLuaCArgs =
    lib.optionalString (resolvedExtraLuaPackages != [ ])
      ''--suffix LUA_CPATH ";" "${
        lib.concatMapStringsSep ";" luaPackages.getLuaPath resolvedExtraLuaPackages
      }"'';

  extraMakeWrapperLuaArgs =
    lib.optionalString (resolvedExtraLuaPackages != [ ])
      ''--suffix LUA_PATH ";" "${
        lib.concatMapStringsSep ";" luaPackages.getLuaPath resolvedExtraLuaPackages
      }"'';

  neovim-wrapped = wrapNeovimUnstable neovim-unwrapped {
    inherit
      extraPython3Packages
      withPython3
      withRuby
      withNodeJs
      viAlias
      vimAlias
      wrapRc
      ;

    plugins = normalizedPlugins;
    luaRcContent = initLua;
    wrapperArgs = extraMakeWrapperArgs + " " + extraMakeWrapperLuaCArgs + " " + extraMakeWrapperLuaArgs;
  };
in
if customAppName then
  neovim-wrapped.overrideAttrs (oldAttrs: {
    buildPhase = oldAttrs.buildPhase + ''
      mv $out/bin/nvim $out/bin/${lib.escapeShellArg appName}
    '';

    meta.mainProgram = appName;
  })
else
  neovim-wrapped
