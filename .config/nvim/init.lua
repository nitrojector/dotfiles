-- constants
VIMRC_PATH='~/.vimrc'

-- source .vimrc
vim.cmd('source ' .. VIMRC_PATH)

-- colorscheme
vim.cmd([[colorscheme monokai-pro]])

-- LSPs
local lspconf = require('lspconfig')

lspconf.pyright.setup{}
lspconf.clangd.setup{}
lspconf.ts_ls.setup{}
lspconf.gopls.setup{}

-- Treesitter
require'nvim-treesitter.configs'.setup {
	ensure_installed = {
		"c",
		"cpp",
		"python",
		"typescript",
		"javascript",
		"lua",
		"json",
		"yaml",
		"html",
		"css",
		"bash",
		"go",
		"markdown",
		"markdown_inline",
		"php",
		"vim",
		"vimdoc"
	},
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
	}
}

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	buffer = buffer,
	callback = function()
		if not vim.lsp.buf.format({ async = false }) then
		end
	end
})

-- copy @ -> + on focus lost
-- vim.api.nvim_create_autocmd({ "FocusLost" }, {
-- 	pattern = { "*" },
-- 	command = [[call setreg("+", getreg("@"))]],
-- })


-- Automatically re-indent the entire file on save
-- vim.api.nvim_create_autocmd("BufWritePre", {
--	pattern = "*",
--	command = "normal! gg=G``"
-- })

-- Automatically convert spaces to tabs before saving the file
-- vim.api.nvim_create_autocmd("BufWritePre", {
--	pattern = "*",
--	command = "retab!"
-- })

vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)

vim.diagnostic.config({
  virtual_text = false, -- Turn off inline diagnostics
})

-- Show all diagnostics on current line in floating window
vim.api.nvim_set_keymap(
  'n', '<Leader>d', ':lua vim.diagnostic.open_float()<CR>',
  { noremap = true, silent = true }
)
-- Go to next diagnostic (if there are multiple on the same line, only shows
-- one at a time in the floating window)
vim.api.nvim_set_keymap(
  'n', '<Leader>n', ':lua vim.diagnostic.goto_next()<CR>',
  { noremap = true, silent = true }
)
-- Go to prev diagnostic (if there are multiple on the same line, only shows
-- one at a time in the floating window)
vim.api.nvim_set_keymap(
  'n', '<Leader>p', ':lua vim.diagnostic.goto_prev()<CR>',
  { noremap = true, silent = true }
)
