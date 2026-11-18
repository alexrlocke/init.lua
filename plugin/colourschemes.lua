vim.pack.add({
	{ src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
	{ src = "https://github.com/folke/tokyonight.nvim", name = "tokyo-night" },
	"https://github.com/sainnhe/gruvbox-material",
	{ src = "https://github.com/dracula/vim", name = "dracula" },
})

local colorscheme_file = vim.fn.stdpath("data") .. "/colorscheme.txt"

-- Clear backgrounds so the terminal's transparency shows through, whatever the theme.
local function clear_bg()
	for _, group in ipairs({
		"Normal",
		"NormalNC",
		"NormalFloat",
		"FloatBorder",
		"SignColumn",
		"LineNr",
		"EndOfBuffer",
		"StatusLine",
		"StatusLineNC",
		"SnacksDashboardNormal",
	}) do
		local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
		vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", hl, { bg = "none", ctermbg = "none" }))
	end
end

-- neorex turns this off (after/plugin/neorex.lua)
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("persist-colorscheme", { clear = true }),
	callback = function()
		clear_bg()
		vim.fn.writefile({ vim.g.colors_name }, colorscheme_file)
		vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#e0def4" })
	end,
})

local saved = vim.fn.filereadable(colorscheme_file) == 1 and vim.fn.readfile(colorscheme_file)[1]
pcall(vim.cmd.colorscheme, saved or "tokyonight-moon")
