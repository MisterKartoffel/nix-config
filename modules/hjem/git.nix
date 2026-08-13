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
        whitespace = "error";
      };

      column.ui = "auto";
      commit.gpgsign = true;
      fetch.prune = true;
      help.autocorrect = "prompt";
      init.defaultBranch = "main";
      merge.conflictstyle = "zdiff3";
      pager.branch = false;
      push.autoSetupRemote = true;

      diff = {
        tool = "nvimdiff";
        algorithm = "histogram";
        renames = "copies";
      };

      log = {
        abbrevCommit = true;
        graphColors = "blue,yellow,cyan,magenta,green,red";
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
    };
  };
}
