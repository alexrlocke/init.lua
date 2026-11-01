vim.pack.add({ {
	src = "https://github.com/rose-pine/neovim",
	name = "rose-pine",
} })

vim.pack.add({ {
	src = "https://github.com/folke/tokyonight.nvim",
	name = "tokyo-night",
} })

vim.pack.add({ {
	src = "https://github.com/sainnhe/gruvbox-material",
	name = "gruvbox-material",
} })

vim.pack.add({ {
	src = "https://github.com/dracula/vim.git",
	name = "dracula",
} })

local colorscheme_file = vim.fn.stdpath("data") .. "/colorscheme.txt"

local saved = vim.fn.filereadable(colorscheme_file) == 1
		and vim.fn.trim(table.concat(vim.fn.readfile(colorscheme_file), "\n"))
	or "tokyonight-moon"
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

if saved ~= "" then
	pcall(vim.cmd.colorscheme, saved)
end
clear_bg()

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("persist-colorscheme", { clear = true }),
	callback = function()
		vim.fn.writefile({ vim.g.colors_name }, colorscheme_file)
		clear_bg()
	end,
})

-- vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#908caa" }) -- lines above cursor
-- vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#908caa" }) -- lines below cursor
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#e0def4" }) -- current line number
