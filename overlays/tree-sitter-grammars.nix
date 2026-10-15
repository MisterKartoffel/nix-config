_: final: prev: {
  tree-sitter-grammars = prev.tree-sitter-grammars.overrideScope (
    _: prev': {
      /*
        This is the cleanest way I found to inject custom grammars
        into vimPlugins.nvim-treesitter.withPlugins, other than
        overriding the entire function. This is because withPlugins
        pulls from builtGrammars (before it's exposed in passthru)
        and tree-sitter-grammars.derivations.
      */
      derivations = (prev'.derivations or { }) // {
        muttrc = final.tree-sitter.buildGrammar {
          language = "muttrc";
          version = "2026-07-26";
          src = final.fetchFromGitHub {
            owner = "neomutt";
            repo = "tree-sitter-muttrc";
            rev = "da8af7ba87b1bbe6d9e1606dfdc5eceb0fccc2dc";
            hash = "sha256-TR11ezKjO0HdKUKD/wMebP+Ybmw0I6PGMFMv/heEwGY=";
          };
        };
      };
    }
  );
}
