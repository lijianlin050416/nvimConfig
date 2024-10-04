local opt = vim.opt
opt.number = true
opt.relativenumber = true
vim.opt.termguicolors = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.opt.tabstop    = 2
vim.opt.shiftwidth = 2

local opts = { noremap = true, silent = true }

-- space + e 快捷键 打开nvim-tree
vim.g.mapleader    = " "
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', opts)

vim.opt.guicursor = { --配置nvim的光标样式
	"i:ver25",
	"a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
}

require("lazy").setup("plugins") --使用lazy插件

require('lualine').setup { --使用lualine插件（底下的状态栏）
	options = { theme = 'onedark' } --设置lualine的配色主题
}

require('nightfox').setup({ --设置nvim的配色主题
	options = { transparent = true }
})

require("mason").setup({ --使用mason插件
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require("mason-lspconfig").setup()

local cmp = require('cmp') --使用cmp插件（代码补全）

cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body) --使用luasnip作为snippet插件
      end,
    },
    mapping = cmp.mapping.preset.insert({ --配置cmp的快捷键
      ['<C-z>'] = cmp.mapping.complete(),
      ['<C-x>'] = cmp.mapping.abort(),
      ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({ --配置代码补全的来源
      { name = 'nvim_lsp' },
			{ name = 'luasnip' }
    }, {
      { name = 'buffer' },
    })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities() --通过此变量 将lsp添加到nvim_lsp的列表中

require'lspconfig'.ts_ls.setup { --lsp ts_ls NEED TO INSTALL BY NPM
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin", --NEED TO INSTALL BY NPM
        location = "/usr/lib/node_modules/@vue/typescript-plugin",
        languages = {"javascript", "typescript", "vue"},
      },
    },
  },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"vue"
	},
	single_file_support = true
}

require("lspconfig").volar.setup { --lsp volar
	capabilities = capabilities,
}

require("lspconfig").cssls.setup { --lsp css NEED TO INSTALL BY NPM
  capabilities = capabilities,
}

require("lspconfig").html.setup { --lsp html NEED TO INSTALL BY NPM
  capabilities = capabilities,
}

vim.cmd("colorscheme nordfox") --设置nvim主题
