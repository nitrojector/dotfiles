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
vim.api.nvim_create_autocmd({ "FocusLost" }, {
	pattern = { "*" },
	command = [[call setreg("+", getreg("@"))]],
})


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
