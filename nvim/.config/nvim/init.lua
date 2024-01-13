-- it's important that this line stays at the top, because the other files
-- need to know the leader key
vim.g.mapleader = " " -- setting the leader key to space

require "plugins"
require "autocompletion"
require "treesitter"
require "_telescope"
require "others"
require "_lualine"
require "_neovide"
--require "_harpoon"
require "_nerdtree"

-- coloscheme
vim.o.termguicolors = true
vim.cmd.colorscheme "catppuccin-mocha"

-- tabs ftw
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = false

vim.api.nvim_exec([[
  set relativenumber
  set number
]], false)

-- using spaces for haskell
vim.cmd[[
augroup haskell_tab_settings
  autocmd!
  autocmd FileType haskell setlocal expandtab
  autocmd FileType haskell setlocal shiftwidth=4
augroup END
]]

vim.api.nvim_set_option('mouse', 'a')

-- i like to see what im searching
vim.opt.hlsearch = true
vim.opt.incsearch = true
-- also who like case sensitive search anyways?
vim.opt.smartcase = true
vim.opt.ignorecase = true
-- treats all characters as literals
-- for patterns use regexes with /\v(pattern)
vim.opt.magic = false

-- make the statusbar faster
vim.opt.cmdheight = 1
vim.opt.updatetime = 50

-- forces me to keep organized
vim.opt.wrap = false
vim.opt.colorcolumn = "80"

-- to create new lines without exiting normal mode
vim.keymap.set('n', '<leader>o', 'o<ESC>')
vim.keymap.set('n', '<leader>O', 'O<ESC>')

-- save with ctrl-s
vim.keymap.set('n', '<c-s>', ':w<CR>', { silent = true })
vim.keymap.set('i', '<c-s>', '<ESC>:w<CR>a', { silent = true })

vim.keymap.set('n', '<c-S>', ':wall<CR>', { silent = true })
vim.keymap.set('i', '<c-S>', '<ESC>:wall<CR>a', { silent = true })

-- system clipboard management
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p')
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P')
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')

-- handy shortcut to start search and replace
vim.keymap.set('n', 'S', ':%s/')
vim.keymap.set('v', 'S', ':s/')

-- switch with the previously opened file
vim.keymap.set('n', '<leader><TAB>', '<c-6>')

-- reload config 
vim.keymap.set('n', '<leader>R', ':source $MYVIMRC<CR>')

-- set the scipt on edit as executable
vim.keymap.set('n', '<leader>x', ':!chmod +x %<CR><CR>')

-- highlight what i'm yanking
vim.cmd 'autocmd! TextYankPost * lua vim.highlight.on_yank { on_visual = false }'
