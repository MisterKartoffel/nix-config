{ pkgs }:
builtins.attrValues { inherit (pkgs) fd imagemagick ripgrep; }
