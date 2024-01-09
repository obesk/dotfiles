vim.keymap.set('n', '<leader>nn', ':NERDTreeFocus<CR>')
vim.keymap.set('n', '<leader>nt', ':NERDTreeTogle<CR>')

vim.keymap.set('n', '<leader>hh', function() require('harpoon.ui').nav_file(1) end)
vim.keymap.set('n', '<leader>hj', function() require('harpoon.ui').nav_file(2) end)
vim.keymap.set('n', '<leader>hk', function() require('harpoon.ui').nav_file(3) end)
vim.keymap.set('n', '<leader>hl;', function() require('harpoon.ui').nav_file(4) end)
