vim.pack.add({
	"https://github.com/folke/snacks.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
})

local Snacks = require("snacks")

local picker_toggles = {
	["<S-h>"] = "toggle_hidden",
	["<S-i>"] = "toggle_ignored",
	["<S-f>"] = "toggle_follow",
}

local exclude = {
	"**/.git/*",
	"**/node_modules/*",
	"**/.yarn/cache/*",
	"**/.yarn/install*",
	"**/.yarn/releases/*",
	"**/.pnpm-store/*",
	"**/.idea/*",
	"**/.DS_Store",
	"build/*",
	"coverage/*",
	"dist/*",
	"hodor-types/*",
	"**/target/*",
	"**/public/*",
	"**/digest*.txt",
	"**/.node-gyp/**",
	"**/tmp/cache/**",
	"**/zig-pkg/*",
	"**/.zig-cache/*",
	"**/zig-out/*",
}

local grep_exclude = vim.list_extend(vim.deepcopy(exclude), {
	"**/.venv/*",
	"**/yarn.lock",
	"certificates/*",
})

-- Snacks centers each header line on its own, so pad every line to the same
-- width (trailing spaces don't survive editors/formatters).
local header = (function()
	local lines = vim.split([[
███▄▄▄▄      ▄████████  ▄██████▄   ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄
███▀▀▀██▄   ███    ███ ███    ███ ███    ███ ███  ▄██▀▀▀███▀▀▀██▄
███   ███   ███    █▀  ███    ███ ███    ███ ███▌ ███   ███   ███
███   ███  ▄███▄▄▄     ███    ███ ███    ███ ███▌ ███   ███   ███
███   ███ ▀▀███▀▀▀     ███    ███ ███    ███ ███▌ ███   ███   ███
███   ███   ███    █▄  ███    ███ ███    ███ ███  ███   ███   ███
███   ███   ███    ███ ███    ███ ███    ███ ███  ███   ███   ███
 ▀█   █▀    ██████████  ▀██████▀   ▀██████▀  █▀    ▀█   ███   █▀]], "\n")
	local width = 0
	for _, line in ipairs(lines) do
		width = math.max(width, vim.fn.strdisplaywidth(line))
	end
	for i, line in ipairs(lines) do
		lines[i] = line .. string.rep(" ", width - vim.fn.strdisplaywidth(line))
	end
	return table.concat(lines, "\n")
end)()

Snacks.setup({
	dashboard = {
		enabled = true,
		preset = { header = header },
		sections = {
			{ section = "header" },
			{ section = "keys", gap = 1, padding = 1 },
			{ section = "recent_files", icon = "", title = "Recent Files", indent = 2, padding = 1 },
			{ section = "projects", icon = "", title = "Projects", indent = 2, padding = 1 },
		},
	},
	picker = {
		layout = { preset = "default" },
		sources = {
			files = {
				hidden = true,
				ignored = true,
				exclude = exclude,
				win = {
					input = {
						keys = vim.tbl_extend("force", picker_toggles, {
							["<C-y>"] = { "yazi_copy_relative_path", mode = { "n", "i" } },
						}),
					},
				},
			},
			grep = {
				hidden = true,
				ignored = true,
				exclude = grep_exclude,
				win = { input = { keys = picker_toggles } },
			},
			explorer = {
				hidden = true,
				ignored = true,
				auto_close = true,
				focus = "list",
				jump = { close = true },
				exclude = { ".git", ".pnpm-store", ".venv", ".DS_Store", "**/.node-gyp/**" },
			},
		},
	},
})

local map = function(lhs, fn, desc, mode)
	vim.keymap.set(mode or "n", lhs, fn, { desc = desc })
end

map("<leader>,", function()
	Snacks.picker.buffers({
		win = {
			input = {
				keys = {
					["dd"] = "bufdelete",
					["<c-d>"] = { "bufdelete", mode = { "n", "i" } },
				},
			},
			list = { keys = { ["dd"] = "bufdelete" } },
		},
	})
end, "Buffers")

-- find
map("<leader>fb", Snacks.picker.buffers, "Buffers")
map("<leader>fc", function()
	Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, "Find Config File")
map("<leader>sf", Snacks.picker.files, "Find Files")
map("<leader>fg", Snacks.picker.git_files, "Find Git Files")
map("<leader>fp", Snacks.picker.projects, "Projects")
map("<leader>fr", Snacks.picker.recent, "Recent")

-- git
map("<leader>gb", Snacks.picker.git_branches, "Git Branches")
map("<leader>gl", Snacks.picker.git_log, "Git Log")
map("<leader>gL", Snacks.picker.git_log_line, "Git Log Line")
map("<leader>gs", Snacks.picker.git_status, "Git Status")
map("<leader>gS", Snacks.picker.git_stash, "Git Stash")
map("<leader>gp", Snacks.picker.git_diff, "Git Diff (Hunks)")
map("<leader>gP", function()
	Snacks.picker.git_diff({ base = "origin" })
end, "Git Diff (origin)")
map("<leader>gf", Snacks.picker.git_log_file, "Git Log File")

-- search
map("<leader>sg", Snacks.picker.grep, "Grep")
map("<leader>sk", Snacks.picker.keymaps, "Keymaps")

-- other
map("<leader>z", function()
	Snacks.zen()
end, "Toggle Zen Mode")
map("<leader>gB", function()
	Snacks.gitbrowse()
end, "Git Browse", { "n", "v" })
map("<leader>gg", function()
	Snacks.lazygit()
end, "Lazygit")
