-- Enable improved vim loader (experimental)
vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Used by some plugins to determine of Nerd Font is installed
vim.g.have_nerd_font = true

-- Configure line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Enable break indent
vim.o.breakindent = true

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- Save undo history
vim.o.undofile = true
--
-- Improve searching
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on
vim.o.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Configure how whitespace is displayed
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", precedes = "◀", extends = "▶" }

-- Expand tabs as spaces
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- Preview substitutions live
vim.o.inccommand = "split"

-- Show which line cursor is on
vim.o.cursorline = true

-- Minimal lines above and below cursor
vim.o.scrolloff = 10

-- Show confirm dialog on some actions
vim.o.confirm = true

-- Ricing
vim.o.termguicolors = true
vim.o.winblend = 15
vim.o.pumblend = 15

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostics to quickfix list
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode with 2x ESC
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Bind j/k to gj/gk when no count was specified (better movement on wrapped lines)
local g_with_key = function(key)
	local gkey = "g" .. key
	return function()
		if vim.v.count == 0 then
			return gkey
		else
			return key
		end
	end
end
vim.keymap.set({ "n", "v" }, "j", g_with_key("j"), { expr = true })
vim.keymap.set({ "n", "v" }, "k", g_with_key("k"), { expr = true })

-- Remap q to Q and Q to <M-q>, to prevent accidental triggering of macro mode
vim.keymap.set("n", "q", "<nop>", { noremap = true })
vim.keymap.set("n", "Q", "q", { noremap = true, desc = "Record macro" })
vim.keymap.set("n", "<M-q>", "Q", { noremap = true, desc = "Replay last register" })

-- [[ Autocmds ]]
require("autocmds.highlight-yank")
require("autocmds.restore-cursor")
require("autocmds.shada-cleanup")
