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

    notifier.enabled = true;
    picker.enabled = true;

    statuscolumn.folds = {
      open = true;
      git_hl = true;
    };
  };
}
