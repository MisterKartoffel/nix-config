fzf --fish | source

set -gx FZF_ALT_C_OPTS "\
  --style full \
  --preview 'eza --all --icons=always --color=always --group-directories-first --tree --level 1 {}' \
  --preview-window '70%' \
  --bind 'backward-eof:abort'"

set -gx FZF_CTRL_T_COMMAND \
  "fd --type file . --exclude .git --exclude .direnv"

set -gx FZF_CTRL_T_OPTS "\
  --style full \
  --preview 'if test -f {}; cat --number {}; end; if test -d {}; eza --all --icons=always --color=always --group-directories-first --tree --level 1 {} \
  --bind 'backward-eof:abort'"

set -gx FZF_CTRL_R_OPTS "\
  --style full"
