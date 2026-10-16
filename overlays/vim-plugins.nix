final: prev: {
  vimPlugins = prev.vimPlugins.extend (
    _: prev': {
      snacks-nvim = prev'.snacks-nvim.overrideAttrs (_: {
        runtimeDeps = builtins.attrValues { inherit (final) fd ripgrep; };
      });

      /*
        typst-preview-nvim is originally overridden to include tinymist
        and websocat in postPatch, this removes that as I expect those
        dependencies to be provided by the environment.
      */
      typst-preview-nvim = prev'.typst-preview-nvim.overrideAttrs (_: {
        postPatch = null;
      });
    }
  );
}
