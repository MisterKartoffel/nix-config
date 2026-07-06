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
    changeDirWidget.options = [
      "--style full"
      "--preview '${lib.getExe pkgs.eza} --all --icons=always --color=always --group-directories-first --tree --level 1 {}'"
      "--preview-window '70%'"
      "--bind 'backward-eof:abort'"
    ];

    fileWidget = {
      command = "${lib.getExe pkgs.fd} --type file --base-directory ${projects} --exclude .git --exclude .direnv";
      options = [
        "--style full"
        "--preview '[[ -f ${projects}/{} ]] && ${lib.getExe' pkgs.coreutils "cat"} --number ${projects}/{}; [[ -d ${projects}/{} ]] && ${lib.getExe pkgs.eza} --all --icons=always --color=always --tree --level 1 ${projects}/{}'"
        "--bind 'backward-eof:abort'"
      ];
    };

    historyWidget.options = [
      "--style full"
      "--reverse"
      "--preview 'echo {}'"
      "--preview-window down:3:hidden:wrap"
      "--bind '?:toggle-preview'"
      "--bind 'backward-eof:abort'"
    ];
  };
}
