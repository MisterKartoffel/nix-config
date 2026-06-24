{
  programs.nvf.settings.vim.utility.snacks-nvim.setupOpts = {
    dashboard = {
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

    notifier.style = {
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

    picker.enabled = true;

    statuscolumn.folds = {
      open = true;
      git_hl = true;
    };
  };
}
