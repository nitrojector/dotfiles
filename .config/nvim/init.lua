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
	pattern = "*.cpp,*.c,*.h",
	buffer = buffer,
	callback = function()
		if not vim.lsp.buf.format({ async = false }) then
		end
	end
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({async = false})
  end
})

vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
vim.keymap.set("n", "grn", vim.lsp.buf.rename)
vim.keymap.set({"n", "v"}, "gra", vim.lsp.buf.code_action)
vim.keymap.set("n", "grr", vim.lsp.buf.references)
vim.keymap.set("n", "gri", vim.lsp.buf.implementation)

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
