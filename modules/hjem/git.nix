{
  osConfig,
  pkgs,
  lib,
  ...
}:
let
  inherit (osConfig.programs) git;
  sshKey = "~/.ssh/id_ed25519";
in
{
  xdg.config.files."git/config" = {
    inherit (git) enable;
    generator = lib.generators.toGitINI;
    value = {
      user = {
        name = "Felipe Duarte";
        email = "felipesdrs@hotmail.com";
        signingkey = sshKey;
      };

      gpg = {
        format = "ssh";
        ssh.defaultKeyCommand = "${lib.getExe' pkgs.openssh "ssh-keygen"} -y -f ${sshKey}";
      };

      core = {
        sshCommand = "${lib.getExe pkgs.openssh} -i ${sshKey}";
        compression = 9;
        pager = "${lib.getExe pkgs.diff-so-fancy} | ${lib.getExe pkgs.less} --tabs=4 -RF";
        whitespace = "error";
      };

      alias."patch" = "add --patch";
      column.ui = "auto";
      commit.gpgsign = true;
      fetch.prune = true;
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
