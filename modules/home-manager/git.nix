{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.modules.secrets) name hotmail;

  inherit (config.programs) ssh;
  sshKey = "${config.home.homeDirectory}/.ssh/id_ed25519";
in
{
  programs.git = lib.mkIf ssh.enable {
    enable = true;

    settings = {
      user = {
        inherit name;
        inherit (hotmail) email;
        signingKey = "${sshKey}.pub";
      };

      core = {
        sshCommand = "${lib.getExe pkgs.ssh} -i ${sshKey}";
        compression = 9;
        editor = "${lib.getExe pkgs.neovim}";
        pager = "${lib.getExe pkgs.diff-so-fancy} | ${lib.getExe pkgs.less} --tabs=4 -RF";
        whitespace = "error";
      };

      alias."patch" = "add --patch";
      column.ui = "auto";
      commit.gpgsign = true;
      fetch.prune = true;
      gpg.format = "ssh";
      help.autocorrect = "prompt";
      init.defaultBranch = "main";
      merge.conflictstyle = "zdiff3";
      push.autoSetupRemote = true;

      diff = {
        tool = "nvimdiff";
        algorithm = "histogram";
        renames = "copies";
      };

      interactive = {
        singleKey = true;
        diffFilter = "${lib.getExe pkgs.diff-so-fancy} --patch";
      };

      log = {
        abbrevCommit = true;
        graphColors = "blue,yellow,cyan,magenta,green,red";
      };

      pager = {
        branch = false;
        diff = "${lib.getExe pkgs.diff-so-fancy} | $PAGER";
      };

      pull = {
        ff = "only";
        rebase = true;
      };

      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };

      rerere = {
        enabled = true;
        autoupdate = true;
      };

      status = {
        branch = true;
        showStash = true;
      };

      color = {
        "branch" = {
          current = "magenta";
          local = "default";
          remote = "yellow";
          upstream = "green";
          plain = "blue";
        };

        "decorate" = {
          HEAD = "red";
          branch = "blue";
          remoteBranch = "magenta";
        };

        "diff" = {
          meta = "black bold";
          frag = "magenta";
          context = "white";
          whitespace = "yellow reverse";
          old = "red";
        };
      };
    };
  };
}
