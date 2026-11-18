-- Running in neorex: its colorscheme, and pickers in Rex's command palette
-- instead of snacks.
--
-- This is in after/plugin so it loads after the files in plugin/, and what it
-- sets replaces what they set.

-- neorex sets this before init.lua runs, and adds its colorscheme to the
-- runtime path itself.
if not vim.g.neorex then
	return
end

-- colorscheme: neorex's, made of the terminal's palette. It has no
-- backgrounds to clear except the statusline bar, which comes from Rex's
-- palette and stays, and it only works inside neorex, so it mustn't be saved
-- as the one plain Neovim starts with. plugin/colourschemes.lua's handler does
-- both on every ColorScheme, so turn it off here.
pcall(vim.api.nvim_del_augroup_by_name, "persist-colorscheme")
pcall(vim.cmd.colorscheme, "neorex")

-- vim.ui.select and vim.ui.input ask in Rex's palette: code actions, rename
-- and any plugin that asks through them. With no Rex app to ask, snacks
-- asks, as without neorex.
vim.g.neorex_config = { ui = { select = "rex", input = "rex" } }

local rex = require("neorex.pick")

local function map(keys, func, desc, opts)
	vim.keymap.set("n", keys, func, vim.tbl_extend("force", { desc = desc .. " (Rex)" }, opts or {}))
end

-- find and search (<leader>, stays on snacks: Rex can't delete buffers with dd)
map("<leader>fb", rex.buffers, "Buffers")
map("<leader>sf", rex.files, "Find Files")
map("<leader>fg", rex.git_files, "Find Git Files")
map("<leader>fr", rex.recent, "Recent")
map("<leader>sg", rex.grep, "Grep")

-- LSP: these replace the buffer-local mappings nvim-lspconfig.lua makes on
-- LspAttach. This autocmd is made after that one, so it runs after it.
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("neorex-lsp-attach", { clear = true }),
	callback = function(event)
		local function lsp(keys, func, desc)
			map(keys, func, "LSP: " .. desc, { buffer = event.buf })
		end
		lsp("grr", rex.lsp_references, "[G]oto [R]eferences")
		lsp("gri", rex.lsp_implementations, "[G]oto [I]mplementation")
		lsp("grd", rex.lsp_definitions, "[G]oto [D]efinition")
		lsp("grD", rex.lsp_declarations, "[G]oto [D]eclaration")
		lsp("gO", rex.lsp_symbols, "Open Document Symbols")
		lsp("gW", rex.lsp_workspace_symbols, "Open Workspace Symbols")
		lsp("grt", rex.lsp_type_definitions, "[G]oto [T]ype Definition")
	end,
})
