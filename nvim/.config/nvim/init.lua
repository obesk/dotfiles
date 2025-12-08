-- some configurations taken from https://github.com/radleylewis/nvim-lite/blob/youtube_demo/init.lua
vim.g.mapleader = " " -- setting the leader key to space
vim.g.maplocalleader = " " -- Set local leader key (NEW)

require("config.lazy")
require("lazy").setup("plugins")

vim.opt.splitbelow = true -- Horizontal splits go below
vim.opt.splitright = true -- Vertical splits go right

-- coloscheme (actual colorscheme set by lazy)
-- vim.o.termguicolors = true

-- Basic settings
vim.opt.number = true -- Line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.cursorline = true -- Highlight current line
vim.opt.wrap = false -- Don't wrap lines
vim.opt.scrolloff = 10 -- Keep 10 lines above/below cursor
vim.opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor

-- File handling
vim.opt.backup = false -- Don't create backup files
vim.opt.writebackup = false -- Don't create backup before writing
vim.opt.swapfile = false -- Don't create swap files
vim.opt.undofile = true -- Persistent undo
-- vim.opt.undodir = vim.fn.expand("~/.vim/undodir")  -- Undo directory
vim.opt.updatetime = 300 -- Faster completion
vim.opt.timeoutlen = 500 -- Key timeout duration
vim.opt.ttimeoutlen = 0 -- Key code timeout
vim.opt.autoread = true -- Auto reload files changed outside vim
vim.opt.autowrite = false -- Don't auto save

-- Split behavior
vim.opt.splitbelow = true -- Horizontal splits go below
vim.opt.splitright = true -- Vertical splits go right

-- i like to see what im searching
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- also who like case sensitive search anyways?
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.magic = false -- treats all characters as literals for patterns use regexes with /\v(pattern)

-- forces me to stay organized
vim.opt.wrap = false
vim.opt.colorcolumn = "80"

vim.keymap.set("n", "<leader>c", ":nohlsearch<CR>", { desc = "Clear search highlights" })
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

-- Splitting & Resizing
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Move lines up/down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Better indenting in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- tabs ftw
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = false

-- file specific settings
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "lua", "python" },
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.expandtab = true
	end,
})

-- to create new lines without exiting normal mode
vim.keymap.set("n", "<leader>o", "o<ESC>")
vim.keymap.set("n", "<leader>O", "O<ESC>")

-- save with ctrl-s
vim.keymap.set("n", "<c-s>", ":w<CR>", { silent = true })
vim.keymap.set("i", "<c-s>", "<ESC>:w<CR>a", { silent = true })

vim.keymap.set("n", "<c-S-s>", ":wall<CR>", { silent = true })
vim.keymap.set("i", "<c-S-s>", "<ESC>:wall<CR>a", { silent = true })

-- system clipboard management (yanking and pasting)
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')
vim.keymap.set({ "n", "v" }, "<leader>P", '"+P')
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')

-- handy shortcut to start search and replace
vim.keymap.set("n", "S", ":%s/")
vim.keymap.set("v", "S", ":s/")

-- switch with the previously opened file
vim.keymap.set("n", "<leader><TAB>", "<c-6>")

-- set the scipt on edit as executable
vim.keymap.set("n", "<leader>x", ":!chmod +x %<CR><CR>")

-- highlight what i'm yanking
vim.cmd("autocmd! TextYankPost * lua vim.highlight.on_yank { on_visual = false }")

-- use esc to go in normal mode on the terminal
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])
vim.api.nvim_create_autocmd("TermClose", {
	callback = function()
		vim.cmd("bp")
	end,
})
