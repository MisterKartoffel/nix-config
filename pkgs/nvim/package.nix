{
  lib,
  neovim-unwrapped,
  wrapNeovimUnstable,
  vimPlugins,

  appName ? "nvim",
  treesitter ? import ./nix/treesitter.nix { inherit vimPlugins; },
  runtimePaths ? import ./nix/runtime.nix { inherit lib; },
  plugins ? import ./nix/plugins.nix { inherit vimPlugins; },
  extraPackages ? [ ],
  initLuaPre ? "",
  wrapRc ? true,
}:
assert lib.assertMsg (appName != null && appName != "") "Neovim appName must be a non-empty string";

let
  nvimRtp = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions runtimePaths;
  };

  neovim-wrapped = wrapNeovimUnstable neovim-unwrapped {
    inherit wrapRc;
    vimAlias = appName == "nvim";
    viAlias = appName == "nvim";
    plugins = plugins ++ [ treesitter ];

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
neovim-wrapped.overrideAttrs (oldAttrs: lib.optionalAttrs (appName != "nvim") {
  postBuild = (oldAttrs.postBuild or "") + ''
    mv $out/bin/nvim $out/bin/${lib.escapeShellArg appName}
  '';

  meta = (oldAttrs.meta or { }) // {
    mainProgram = appName;
  };
})
