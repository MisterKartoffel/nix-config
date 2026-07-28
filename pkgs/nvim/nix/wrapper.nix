{
  lib,
  neovim-unwrapped,
  stdenvNoCC,
  wrapNeovimUnstable,
}:
{
  appName ? "nvim",
  plugins ? [ ],
  treesitter ? [ ],
  extraPackages ? [ ],
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

  runtimePaths = [
    "after"
    "lsp"
    "lua"
    "plugin"
  ];

  nvimRtp = stdenvNoCC.mkDerivation {
    name = "nvim-rtp";
    src =
      let
        root = ../.;
      in
      lib.fileset.toSource {
        inherit root;
        fileset = lib.fileset.unions (map (path: root + "/${path}") runtimePaths);
      };
    dontUnpack = true;

    installPhase = ''
      for dir in ${builtins.concatStringsSep " " runtimePaths}; do
        mkdir -p "$out/$dir"
        cp -a "$src/$dir/." "$out/$dir/"
      done
    '';
  };

  normalizedPlugins =
    map (
      x:
      {
        plugin = null;
        config = null;
        optional = false;
      }
      // (if x ? plugin then x else { plugin = x; })
    ) plugins
    ++ treesitter;

  initLua = ''
    ${initLuaPre}
    vim.opt.rtp:prepend("${nvimRtp}")
    ${builtins.readFile ../init.lua}
  '';

  luaPackages = neovim-unwrapped.lua.pkgs;
  resolvedExtraLuaPackages = extraLuaPackages luaPackages;
  luaPath = lib.concatMapStringsSep ";" luaPackages.getLuaPath resolvedExtraLuaPackages;

  wrapperArgs = lib.concatStringsSep " " (
    lib.optional customAppName ''--set NVIM_APPNAME "${appName}"''
    ++ lib.optional (extraPackages != [ ]) ''--prefix PATH : "${lib.makeBinPath extraPackages}"''
    ++ lib.optional (resolvedExtraLuaPackages != [ ]) ''
      --suffix LUA_CPATH ";" "${luaPath}"
      --suffix LUA_PATH ";" "${luaPath}"
    ''
  );

  neovim-wrapped = wrapNeovimUnstable neovim-unwrapped {
    inherit
      extraPython3Packages
      withPython3
      withRuby
      withNodeJs
      vimAlias
      viAlias
      wrapRc
      ;

    plugins = normalizedPlugins;
    luaRcContent = initLua;
    inherit wrapperArgs;
  };
in
if customAppName then
  neovim-wrapped.overrideAttrs (oldAttrs: {
    buildPhase = oldAttrs.buildPhase + ''
      mv "$out/bin/nvim" "$out/bin/${lib.escapeShellArg appName}"
    '';

    meta.mainProgram = appName;
  })
else
  neovim-wrapped
