vim.keymap.set('n', '<leader>hm', require('harpoon.mark').add_file)
vim.keymap.set('n', '<leader>hs', require('harpoon.ui').toggle_quick_menu)

vim.keymap.set('n', '<leader>hh', function() require('harpoon.ui').nav_file(1) end)
vim.keymap.set('n', '<leader>hj', function() require('harpoon.ui').nav_file(2) end)
vim.keymap.set('n', '<leader>hk', function() require('harpoon.ui').nav_file(3) end)
vim.keymap.set('n', '<leader>hl', function() require('harpoon.ui').nav_file(4) end)
