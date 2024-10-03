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

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	buffer = buffer,
	callback = function()
		vim.lsp.buf.format({ async = false })
	end
})

-- copy @ -> + when tabbing out
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
