{ config, lib, ... }:
let
  cfg = config.programs.nvf;
in
{
  programs.nvf.settings.vim.git.gitsigns = lib.mkIf cfg.enable {
    enable = true;
    mappings = {
      previousHunk = "[g";
      nextHunk = "]g";
      stageHunk = "<leader>gs";
      resetHunk = "<leader>gr";
      stageBuffer = "<leader>gS";
      resetBuffer = "<leader>gR";
      previewHunk = "<leader>gv";
    };
  };
}
