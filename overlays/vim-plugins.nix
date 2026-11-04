final: prev: {
  vimPlugins = prev.vimPlugins.extend (
    _: prev': {
      oil-git-nvim = prev'.oil-git-nvim.overrideAttrs (_: {
        src = final.fetchFromGitHub {
          owner = "malewicz1337";
          repo = "oil-git.nvim";
          rev = "8bab14df0b7db7a62fa75c8978d6181daed2f0a2";
          hash = "sha256-JqJ1t4Zk4ROUXnFvk63hJw18nq7rXQU5NxnP4HHWXpU=";
        };

        meta.homepage = "https://github.com/malewicz1337/oil-git.nvim";
        meta.license = final.lib.licenses.mit;
      });

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
