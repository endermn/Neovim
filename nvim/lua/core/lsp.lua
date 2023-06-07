-- luacheck: globals vim

local lsp = require("lsp-zero")
lsp.preset("minimal")

local null_ls = require("null-ls")
local b = null_ls.builtins

lsp.on_attach(function(client, bufnr)
	lsp.default_keymaps({ buffer = bufnr })
	vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", { buffer = true })
end)

lsp.format_on_save({
	format_opts = {
		async = false,
		timeout_ms = 10000,
	},
	servers = {
		["null-ls"] = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"html",
			"css",
			"json",
			"lua",
			"python",
			"sh",
			"bash",
			"zsh",
			"go",
			"rust",
			"cpp",
			"c",
			"cmake",
			"make",
			"markdown",
		},
	},
})

lsp.set_sign_icons({
	error = "✘",
	warn = "▲",
	hint = "⚑",
	info = "»",
})

require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())
lsp.ensure_installed({
	"bashls",
	"clangd",
	"cmake",
	"cssls",
	"html",
	"jsonls",
	"lua_ls",
	"pyright",
	"taplo",
	"rust_analyzer",
	"tsserver",
})

lsp.setup()

local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
	preselect = "item",
	completion = {
		completeopt = "menu,menuone,noinsert",
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	formatting = {
		fields = { "abbr", "kind", "menu" },
		format = require("lspkind").cmp_format({
			maxwidth = 50,
			ellipsis_char = "...",
		}),
	},
	mapping = {
		["<CR>"] = cmp.mapping.confirm({ select = false }),
		["<Tab>"] = cmp_action.luasnip_supertab(),
		["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
		["<ESC>"] = cmp.mapping.abort(),
		["<C-j>"] = cmp.mapping.scroll_docs(-4),
		["<C-k"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),

		["<C-f>"] = cmp_action.luasnip_jump_forward(),
		["<C-b>"] = cmp_action.luasnip_jump_backward(),
	},
	sources = {
		{
			name = "path",
			option = {
				trailing_slash = true,
			},
		},
		{ name = "path" },
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "buffer", keyword_length = 1 },
		{ name = "luasnip", keyword_length = 1 },
	},
})

null_ls.setup({
	sources = {
		b.completion.luasnip,
		b.completion.tags,
		b.formatting.stylua,
		b.formatting.autopep8,
		b.formatting.beautysh,
		b.formatting.cbfmt,
		b.formatting.gofumpt,
		b.formatting.jq,
		b.formatting.cmake_format,
		b.formatting.prettierd.with({
			filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"html",
				"css",
			},
		}),
		b.diagnostics.misspell,
		b.diagnostics.luacheck,
		b.diagnostics.checkmake,
		b.diagnostics.clang_check,
		b.diagnostics.cmake_lint,
		b.diagnostics.markdownlint,
		b.diagnostics.pylint,
		b.diagnostics.revive,
		b.diagnostics.xo,
		b.code_actions.cspell,
		b.code_actions.xo,
		b.code_actions.gitrebase,
		b.code_actions.gitsigns,
		b.code_actions.gomodifytags,
		b.code_actions.proselint,
		b.code_actions.refactoring,
		b.hover.dictionary,
	},
})

require("mason-null-ls").setup({
	ensure_installed = nil,
	automatic_installation = true,
})
