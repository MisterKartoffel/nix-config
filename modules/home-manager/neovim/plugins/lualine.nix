{ config, lib, ... }:
let
  cfg = config.programs.nvf;
in
{
  programs.nvf.settings.vim.statusline.lualine = lib.mkIf cfg.enable {
    enable = true;
    icons.enable = true;

    activeSection = {
      b = [
        ''
          { "b:gitsigns_head", icon = "", },
          { "diff", source = diff_source, },
          { "diagnostics", },
        ''
      ];
      c = [
        ''
          {
          	"filename",
          	symbols = {
          		modified = "",
          		readonly = "󱀰",
          		unnamed = "󱀶",
          		newfile = "",
          	},
          }
        ''
      ];
      y = [
        ''
          { "filetype", },
        ''
      ];
    };
  };
}
