vim.pack.add({
	{ src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
	{ src = "https://github.com/folke/tokyonight.nvim", name = "tokyo-night" },
	"https://github.com/sainnhe/gruvbox-material",
	{ src = "https://github.com/dracula/vim", name = "dracula" },
})

-- neorex starts Neovim with `--listen $TMPDIR/neorex-<pid>.nvim.sock`
local in_neorex = vim.v.servername:match("/neorex%-%d+%.nvim%.sock$") ~= nil
if in_neorex then
	vim.opt.rtp:append(vim.fn.expand("~/code/neorex/runtime"))
end

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
		-- neorex's statusline bar comes from Rex's palette, so keep it
		if not (in_neorex and group:match("^StatusLine")) then
			local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
			vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", hl, { bg = "none", ctermbg = "none" }))
		end
	end
end

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("persist-colorscheme", { clear = true }),
	callback = function()
		clear_bg()
		-- neorex only works inside neorex, so don't save it
		if vim.g.colors_name == "neorex" then
			return
		end
		vim.fn.writefile({ vim.g.colors_name }, colorscheme_file)
		vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#e0def4" })
	end,
})

local saved = vim.fn.filereadable(colorscheme_file) == 1 and vim.fn.readfile(colorscheme_file)[1]
pcall(vim.cmd.colorscheme, in_neorex and "neorex" or saved or "tokyonight-moon")
