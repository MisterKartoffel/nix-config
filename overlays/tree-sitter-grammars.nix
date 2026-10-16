_: final: prev: {
  tree-sitter-grammars = prev.tree-sitter-grammars.overrideScope (
    _: _: {
      tree-sitter-muttrc = final.tree-sitter.buildGrammar {
        language = "muttrc";
        version = "2026-07-26";
        src = final.fetchFromGitHub {
          owner = "neomutt";
          repo = "tree-sitter-muttrc";
          rev = "da8af7ba87b1bbe6d9e1606dfdc5eceb0fccc2dc";
          hash = "sha256-TR11ezKjO0HdKUKD/wMebP+Ybmw0I6PGMFMv/heEwGY=";
        };
      };
    }
  );
}
