{
  lib,
  neovim-unwrapped,
  wrapNeovimUnstable,
  linkFarm,

  appName ? "nvim",
  runtimePaths ? [ ],
  plugins ? [ ],
  treesitter ? [ ],
  extraPackages ? [ ],
  luaPackages ? neovim-unwrapped.lua.pkgs,
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

  nvimRtp = linkFarm "nvim-rtp" (
    map (path: {
      name = baseNameOf (toString path);
      inherit path;
    }) runtimePaths
  );

  resolvedExtraLuaPackages = extraLuaPackages luaPackages;
  luaPath = lib.concatMapStringsSep ";" luaPackages.getLuaPath resolvedExtraLuaPackages;

  neovim-wrapped = wrapNeovimUnstable neovim-unwrapped {
    plugins =
      map (
        x:
        {
          config = null;
          optional = false;
        }
        // (if x ? plugin then x else { plugin = x; })
      ) plugins
      ++ [ treesitter ];

    luaRcContent = builtins.concatStringsSep "\n" [
      initLuaPre
      ''vim.opt.rtp:prepend("${nvimRtp}")''
      (builtins.readFile ./init.lua)
    ];

    wrapperArgs = builtins.concatStringsSep " " (
      lib.optional customAppName ''--set NVIM_APPNAME "${appName}"''
      ++ lib.optional (extraPackages != [ ]) ''--prefix PATH : "${lib.makeBinPath extraPackages}"''
      ++ lib.optional (resolvedExtraLuaPackages != [ ]) ''
        --suffix LUA_CPATH ";" "${luaPath}"
        --suffix LUA_PATH ";" "${luaPath}"
      ''
    );

    inherit
      extraPython3Packages
      withPython3
      withRuby
      withNodeJs
      vimAlias
      viAlias
      wrapRc
      ;
  };
in
if customAppName then
  neovim-wrapped.overrideAttrs (oldAttrs: {
    postInstall = oldAttrs.postInstall + ''
      mv "$out/bin/nvim" "$out/bin/${lib.escapeShellArg appName}"
    '';

    meta.mainProgram = appName;
  })
else
  neovim-wrapped
