{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShellNoCC {
  packages = builtins.attrValues {
    inherit (pkgs)
      tack
      nil
      lua-language-server
      ;
  };

  env = {
    TACK_NIX_CONF_TOKENS = 1;
  };

  shellHook = /* bash */ ''
    if [[ ! -f .envrc ]]; then
    cat << 'EOF' > .envrc
    watch_file shell.nix
    use flake
    export NH_FLAKE=''${PWD}
    EOF
    fi
  '';
}
