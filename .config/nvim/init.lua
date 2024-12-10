-- nvim-tree disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- constants
VIMRC_PATH='~/.vimrc'

-- source .vimrc
vim.cmd('source ' .. VIMRC_PATH)

--- nvim-tree
require('nvim-tree').setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 35,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
	git_ignored = true,
  },
  diagnostics = {
	enable = true,
	show_on_dirs = true,
  },
})

local ntapi = require('nvim-tree.api')
vim.keymap.set('n', '<leader>t', function() ntapi.tree.toggle() end)

-- LSPs
local lspconf = require('lspconfig')

lspconf.pyright.setup{}
lspconf.clangd.setup{}
lspconf.ts_ls.setup{}
lspconf.gopls.setup{}

-- vim-cmp
local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<C-y>'] = cmp.mapping.confirm({ select = true }),
	  -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' }, -- For luasnip users.
    }, {
      { name = 'buffer' },
    })
  })

  -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
  -- Set configuration for specific filetype.
  --[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
 })
 require("cmp_git").setup() ]]--

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  require('lspconfig')['pyright'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['clangd'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['ts_ls'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['gopls'].setup {
    capabilities = capabilities
  }

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

--- Harpoon
local harpoon = require("harpoon")
harpoon:setup()

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-g>", function() -- WIP: WARN: This does nth, it doesn't select file
										-- also have to think of a way to delete files in harpoon
	require('fzf-lua').fzf_exec(function(cb)
		local hplist = require('harpoon'):list()

		if not hplist or not hplist.items then
			cb()
			return
		end

		for _, item in ipairs(hplist.items) do
			cb(item.value)
		end

		cb()
	end, {
	prompt = "Harpoon|>",
	debug = true,
	winopts = {
		height = 0.50,
		width = 0.40,
		row = 0.50,
		col = 0.50,
		border = true,
	},
})
end)



vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

--- LSP
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
vim.keymap.set("n", "grn", vim.lsp.buf.rename)
vim.keymap.set({"n", "v"}, "gra", vim.lsp.buf.code_action)
vim.keymap.set("n", "grr", vim.lsp.buf.references)
vim.keymap.set("n", "gri", vim.lsp.buf.implementation)

vim.diagnostic.config({
  virtual_text = false, -- Turn off inline diagnostics
})

-- Show function signature
-- vim.api.nvim_set_keymap(
--   'n', '<C-h>', ':lua vim.lsp.buf.signature_help()<CR>',
--   { noremap = true, silent = true }
-- )
--
-- vim.api.nvim_set_keymap(
--   'i', '<C-h>', '<C-o>:lua vim.lsp.buf.signature_help()<CR>',
--   { noremap = true, silent = true }
-- )

-- Show references/usages
vim.api.nvim_set_keymap(
  'n', '<Leader>u', ':lua vim.lsp.buf.references()<CR>',
  { noremap = true, silent = true }
)

-- Show all diagnostics on current line in floating window
vim.api.nvim_set_keymap(
  'n', '<Leader>d', ':lua vim.diagnostic.open_float()<CR>',
  { noremap = true, silent = true }
)

-- Go to next diagnostic (if there are multiple on the same line, only shows
-- one at a time in the floating window)
vim.api.nvim_set_keymap(
  'n', '<C-n>', ':lua vim.diagnostic.goto_next()<CR>',
  { noremap = true, silent = true }
)

-- Go to prev diagnostic (if there are multiple on the same line, only shows
-- one at a time in the floating window)
vim.api.nvim_set_keymap(
  'n', '<C-p>', ':lua vim.diagnostic.goto_prev()<CR>',
  { noremap = true, silent = true }
)
