-- constants
VIMRC_PATH='~/.vimrc'

-- source .vimrc
vim.cmd('source ' .. VIMRC_PATH)

-- Treesitter
--- FZF
fzfl_opts = {
  winopts = {
	height = 0.70,
	width = 0.60,
	row = 0.10,
	col = 0.50,
	border = true,
  },
  fzf_opts = {
	['--ansi'] = true,
	['--layout'] = 'reverse',
  },
  files = {
	preview_cmd = 'bat --color=always --style=header,grid --line-range :500 {}',
  },
  live_grep = {
	  cmd = 'rg',
  }
}

fzfl = require('fzf-lua')
fzfl.setup(fzfl_opts)

vim.keymap.set('n', '<leader>ff', function() fzfl.files() end)
vim.keymap.set('n', '<leader>fl', function() fzfl.live_grep() end)
vim.keymap.set('n', '<leader>fg', function() fzfl.git_files() end)
-- vim.keymap.set('n', '<leader>fb', function() fzfl.buffers() end) -- I just don't use buffers
vim.keymap.set('n', '<leader>fb', function() fzfl.git_blame() end)
vim.keymap.set('n', '<leader>fh', function() fzfl.helptags() end)
vim.keymap.set('n', '<leader>fr', function() fzfl.resume() end)
vim.keymap.set('n', '<leader>fu', function() fzfl.lsp_references() end)

