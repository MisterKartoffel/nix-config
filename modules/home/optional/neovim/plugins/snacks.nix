{ pkgs, ... }:
{
  home.packages = with pkgs; [ ripgrep ];

  programs.nvf.settings.vim.utility.snacks-nvim = {
    enable = true;

    setupOpts = {
      dashboard = {
        enabled = true;
        preset = {
          pick = "fzf-lua";
          header = ''
                  ████ ██████           █████      ██⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                 ███████████             █████ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                 █████████ ███████████████████ ███   ███████████⠀⠀
                █████████  ███    █████████████ █████ ██████████████⠀⠀
               █████████ ██████████ █████████ █████ █████ ████ █████⠀⠀
             ███████████ ███    ███ █████████ █████ █████ ████ █████⠀
            ██████  █████████████████████ ████ █████ █████ ████ ██████
          '';
        };
        sections = [
          { section = "header"; }
          {
            icon = " ";
            title = "Keymaps";
            section = "keys";
            indent = 2;
            padding = 1;
          }
          {
            icon = " ";
            title = "Recent Files";
            section = "recent_files";
            indent = 2;
            padding = 1;
          }
        ];
      };

      notifier = {
        enabled = true;
        style = {
          border = "rounded";
          zindex = 100;
          ft = "markdown";
          wo = {
            winblend = 5;
            wrap = false;
            conceallevel = 2;
            colorcolumn = "";
          };
          bo.filetype = "snacks_notif";
        };
      };

      picker.enabled = true;

      statuscolumn = {
        enabled = true;
        folds = {
          open = true;
          git_hl = true;
        };
      };
    };
  };
}
