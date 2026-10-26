-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')
vim.keymap.set("i", "<Esc>", '<cmd>echo "Use jk to escape!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "Move focus to the upper window" })

-- Custom keymaps
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up centered" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yank" })
vim.keymap.set("n", "<leader>d", '"_d', { desc = "Delete without yank" })
vim.keymap.set("v", "<leader>d", '"_d', { desc = "Delete without yank" })

vim.keymap.set("i", "jk", "<Esc>", { noremap = false })
vim.keymap.set("n", "n", "nzzzv", { noremap = false })

vim.keymap.set("n", "<leader>x", ":bd<CR>", { desc = "Close buffer" })
-- Use Alt/Option + Arrow keys instead
vim.keymap.set("n", "<M-Right>", "<cmd>vertical resize +2<cr>")
vim.keymap.set("n", "<M-Left>", "<cmd>vertical resize -2<cr>")
vim.keymap.set("n", "<M-Up>", "<cmd>resize +2<cr>")
vim.keymap.set("n", "<M-Down>", "<cmd>resize -2<cr>")

-- LSP (grn/gra/grr/gri/grt/gO are Neovim 0.11 defaults; picker versions are buffer-local in plugin/nvim-lspconfig.lua)
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })

vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })

-- Stay in visual mode when indenting
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

vim.keymap.set("n", "-", "<cmd>Oil<CR>")

-- Render the current markdown file with glow in a floating terminal (q to close)
vim.keymap.set("n", "<leader>rm", function()
	if vim.bo.filetype ~= "markdown" then
		vim.notify("Not a markdown file", vim.log.levels.WARN)
		return
	end
	local file = vim.fn.expand("%:p")
	local width = math.floor(vim.o.columns * 0.8)
	Snacks.terminal({ "glow", "-p", "-w", tostring(width - 4), file }, {
		win = { style = "float", width = 0.8, height = 0.8, border = "rounded" },
	})
end, { desc = "[R]ender [M]arkdown (glow)" })
