if vim.g.neovide then
	vim.opt.guifont = { "MonoLisa", ":h10" }
	vim.g.neovide_scale_factor = 1
	local change_size = function(factor)
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * factor
	end
	vim.keymap.set('n', '<c-=>', function() change_size(1.1) end)
	vim.keymap.set('n', '<c-->', function() change_size(1 / 1.1) end)
	vim.keymap.set('n', '<c-0>', function() vim.g.neovide_scale_factor = 1 end)
end
-- vim.opt.clipboard = "unnamedplus"
