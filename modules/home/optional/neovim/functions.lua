---@diagnostic disable: unused-function, unused-local, undefined-global
-- Used in ./plugins/oil.nix setupOpts
function _G.get_oil_winbar()
	local path = vim.fn.expand("%")
	path = path:gsub("oil://", "")

	return vim.fn.fnamemodify(path, ":~")
end

-- Used in ./plugins/lualine.nix activeSection b
local function diff_source()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.modified,
			removed = gitsigns.removed,
		}
	end
end
