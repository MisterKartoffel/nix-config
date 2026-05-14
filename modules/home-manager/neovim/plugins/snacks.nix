{ config, lib, ... }:
let
  cfg = config.programs.nvf;
in
{
  programs.nvf.settings.vim = lib.mkIf cfg.enable {
    utility.snacks-nvim = {
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

    keymaps = [
      # Pickers
      {
        mode = "n";
        key = "<leader>fs";
        action = "function() Snacks.picker.smart() end";
        desc = "Find files among open buffers, recent files and files in cwd";
        lua = true;
        silent = true;
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "function() Snacks.picker.grep() end";
        desc = "Grep for string in cwd";
        lua = true;
        silent = true;
      }
      {
        mode = "n";
        key = "<leader>fp";
        action = "function() Snacks.picker() end";
        desc = "Pick a picker";
        lua = true;
        silent = true;
      }

      # LSP
      {
        mode = "n";
        key = "gri";
        action = "function() Snacks.picker.lsp_implementations() end";
        desc = "Go to implementation for current symbol";
        lua = true;
        silent = true;
      }
      {
        mode = "n";
        key = "grr";
        action = "function() Snacks.picker.lsp_references() end";
        desc = "Find references for current symbol";
        lua = true;
        silent = true;
      }
      {
        mode = "n";
        key = "grd";
        action = "function() Snacks.picker.lsp_definitions() end";
        desc = "Go to definition for current symbol";
        lua = true;
        silent = true;
      }
      {
        mode = "n";
        key = "gre";
        action = "function() Snacks.picker.diagnostics() end";
        desc = "Browse diagnostics for current buffer";
        lua = true;
        silent = true;
      }
    ];
  };
}
