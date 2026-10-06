{
  lib,
  neovim-unwrapped,
  wrapNeovimUnstable,
  neovimUtils,
  vimPlugins,
  tree-sitter,
  fetchFromGitHub,
  linkFarm,

  fd,
  ripgrep,

  appName ? "nvim",
  treesitter ? import ./nix/treesitter.nix {
    inherit
      tree-sitter
      fetchFromGitHub
      vimPlugins
      lib
      ;
  },
  runtimePaths ? import ./nix/runtime.nix { inherit lib; },
  plugins ? import ./nix/plugins.nix { inherit vimPlugins; },
  extraPackages ? [
    fd
    ripgrep
  ],
  viAlias ? appName == "nvim",
  vimAlias ? appName == "nvim",
  initLuaPre ? "",
  wrapRc ? true,
}:
assert appName == "" -> throw "Neovim appName cannot be set to an empty string.";
assert appName == null -> throw "Neovim appName cannot be set to null.";

let
  nvimRtp = linkFarm "nvim-rtp" (
    map (path: {
      name = baseNameOf (toString path);
      inherit path;
    }) runtimePaths
  );

  neovim-wrapped = wrapNeovimUnstable neovim-unwrapped {
    inherit wrapRc;
    vimAlias = vimAlias && appName == "nvim";
    viAlias = viAlias && appName == "nvim";

    plugins = neovimUtils.normalizePlugins plugins ++ [ treesitter ];

    luaRcContent = ''
      ${initLuaPre}
      vim.opt.rtp:prepend("${nvimRtp}")
      ${builtins.readFile ./init.lua}
    '';

    wrapperArgs =
      lib.optionals (appName != "nvim") [
        "--set"
        "NVIM_APPNAME"
        appName
      ]
      ++ lib.optionals (extraPackages != [ ]) [
        "--prefix"
        "PATH"
        ":"
        (lib.makeBinPath extraPackages)
      ];
  };
in
if appName == "nvim" then
  neovim-wrapped
else
  neovim-wrapped.overrideAttrs (oldAttrs: {
    postBuild = (oldAttrs.postBuild or "") + ''
      mv "$out/bin/nvim" "$out/bin/${lib.escapeShellArg appName}"
    '';

    meta = (oldAttrs.meta or { }) // {
      mainProgram = appName;
    };
  })
