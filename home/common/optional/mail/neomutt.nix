{ config, ... }:
let
  inherit (config.modules.secrets.email.hotmail) email;
in
{
  accounts.email.accounts.${email}.neomutt = {
    enable = true;

    mailboxName = "Hotmail/Caixa de Entrada";
    extraMailboxes = [
      {
        name = "Hotmail/Arquivo Morto";
        mailbox = "Archive";
      }
      {
        name = "Hotmail/Enviados";
        mailbox = "Sent";
      }
      {
        name = "Hotmail/Rascunhos";
        mailbox = "Drafts";
      }
      {
        name = "Hotmail/Excluído";
        mailbox = "Deleted";
      }
      {
        name = "Hotmail/Lixo Eletrônico";
        mailbox = "Junk";
      }
    ];
  };

  programs.neomutt = {
    enable = true;

    settings = {
      sort = "reverse-last-date";
      use_threads = "threads";
      sort_browser = "unsorted";
      markers = "no";
    };

    binds = [
      {
        map = [
          "attach"
          "browser"
          "index"
          "pager"
        ];
        key = "g";
        action = "noop";
      }
      {
        map = [
          "attach"
          "browser"
          "index"
        ];
        key = "gg";
        action = "first-entry";
      }
      {
        map = [
          "attach"
          "browser"
          "index"
        ];
        key = "G";
        action = "last-entry";
      }
      {
        map = [
          "attach"
          "browser"
          "index"
          "pager"
        ];
        key = "\\Cu";
        action = "half-up";
      }
      {
        map = [
          "attach"
          "browser"
          "index"
          "pager"
        ];
        key = "\\Cd";
        action = "half-down";
      }
      {
        map = [ "pager" ];
        key = "h";
        action = "exit";
      }
      {
        map = [ "index" ];
        key = "l";
        action = "display-message";
      }
      {
        map = [ "pager" ];
        key = "gg";
        action = "top";
      }
      {
        map = [ "pager" ];
        key = "G";
        action = "bottom";
      }
      {
        map = [ "pager" ];
        key = "k";
        action = "previous-line";
      }
      {
        map = [ "pager" ];
        key = "j";
        action = "next-line";
      }
    ];

    macros = [
      {
        map = [ "index" ];
        key = "c";
        action = "<change-folder>?";
      }
    ];

    extraConfig = ''
      ignore *
      unignore subject: from: to: cc: date:
      hdr_order subject: from: to: cc: date:

      # In order: not addressed to me, addressed to me,
      # addressed to group, copied to me, sent by me, mailing list
      set to_chars = "󰫭󰭕󰭘󱉯 "

      # tagged, favorited, marked for deletion,
      # attachment marked for deletion, replied to,
      # old mail, new mail, old mail thread, new mail thread
      set flag_chars = "󰓼󱫃󰼠󰵂󰵂  "

      # unchanged, synchronize, read-only, attach-message
      set status_chars = "󰶉󰁝󰶎󰁦"

      set index_format = " %zs %zt  %-20.20L | %@attachment_info@ %s %*    | %<[m?%<[d?%[hoje, %R]& %[%a, %R]>&%[%d %h %Y]> "
      index-format-hook attachment_info "=B text/calendar ~X 1-" "󰁦"
      index-format-hook attachment_info "=B text/calendar" " "
      index-format-hook attachment_info "~X 1-" "󰁦 "
      index-format-hook attachment_info "~A" "  "

      set compose_format = " Compose %a 󰁦 %* Message size: %l "
      set size_show_bytes = yes
      set size_show_fractions = yes

      set attach_format = " %2n %u%D%I%T | %d %*  | %.7m/%.10m, %s "
      set status_format = " %r %D %?u? %u ?%?R? %R ?%?d? %d ?%?t?󰓼 %t ?%?F? %F ?%?p?󰲶 %p?"
      set mailbox_folder_format = " %2C %<N?󰵂&%<n?&%<m?& >>> %i "
      set pager_format = " %zs %zt %L %s %*  %P "

      # Statusbar Colors ---------------------------------------------
      color status color8   default '(|)'
      color status default  color8  '\s*[^ ]+\s*'
      color status green    color8  '( [0-9]+)?'
      color status blue     color8  '( [0-9]+)?'
      color status color229 color8  '( [0-9]+)?'
      color status color216 color8  '󰓼( [0-9]+)?'
      color status color210 color8  '( [0-9]+)?'
      color status color255 color8  '󰲶( [0-9]+)?'

      # Index Colors -------------------------------------------------
      color index         default  default
      color index_author  color147 default
      color index_date    color245 default
      color index_flags   blue     default
      color index_subject color245 default

      color index_flags   green    default ~U
      color index_subject color252 default ~U

      color index_author  color229 default ~F
      color index_date    color229 default ~F
      color index_flags   color229 default ~F
      color index_subject color229 default ~F

      color index_author  color216 default ~T
      color index_date    color216 default ~T
      color index_flags   color216 default ~T
      color index_subject color216 default ~T

      color index_author  color210 default ~D
      color index_date    color210 default ~D
      color index_flags   color210 default ~D
      color index_subject color210 default ~D

      color normal    color15  default
      color indicator default  black
      color error     color210 default
      color status    color15  default
      color tree      color15  default
      color tilde     color15  default

      color quoted  color15 default
      color quoted1 color7  default
      color quoted2 color8  default
      color quoted3 color0  default
      color quoted4 color0  default
      color quoted5 color0  default

      # Message Headers ----------------------------------------------
      color hdrdefault color245 default
      color header     color189 default '^From:'
      color header     color189 default '^Subject:'

      # Message Body -------------------------------------------------
      # Text formatting (bold, underline, italic)
      color body white default '(^|[[:space:]])\\*[^[:space:]]+\\*([[:space:]]|$)'
      color body white default '(^|[[:space:]])_[^[:space:]]+_([[:space:]]|$)'
      color body white default '(^|[[:space:]])/[^[:space:]]+/([[:space:]]|$)'

      # Attachments
      color attachment color8 default

      # Signature
      color signature color8 default

      # Emails
      color body color2 default '[\-\.+_a-zA-Z0-9]+@[\-\.a-zA-Z0-9]+'

      # URLs
      color body color4 default  '(https?|ftp)://[-\.,/%~_:?&=\#a-zA-Z0-9\+]+'

      # mailto
      color body color2 default '<mailto:[\-\.+_a-zA-Z0-9]+@[\-\.a-zA-Z0-9]+>'
    '';
  };
}
