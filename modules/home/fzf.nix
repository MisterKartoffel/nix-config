{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.xdg.userDirs) projects;
in
{
  programs.fzf = {
    fileWidgetCommand = "${lib.getExe pkgs.fd} --type file --base-directory ${projects} --exclude .git --exclude .direnv";

    changeDirWidgetOptions = [
      "--style full"
      "--preview '${lib.getExe pkgs.eza} --all --icons=always --color=always --group-directories-first --tree --level 1 {}'"
      "--preview-window '70%'"
      "--bind 'backward-eof:abort'"
    ];

    fileWidgetOptions = [
      "--style full"
      "--walker-skip .ssh,.gnupg,.cache"
      "--preview '[[ -f ${projects}/{} ]] && ${lib.getExe' pkgs.coreutils "cat"} --number ${projects}/{}; [[ -d ${projects}/{} ]] && ${lib.getExe pkgs.eza} --all --icons=always --color=always --tree --level 1 ${projects}/{}'"
      "--bind 'backward-eof:abort'"
    ];

    historyWidgetOptions = [
      "--style full"
      "--reverse"
      "--preview 'echo {}'"
      "--preview-window down:3:hidden:wrap"
      "--bind '?:toggle-preview'"
      "--bind 'backward-eof:abort'"
    ];
  };
}
