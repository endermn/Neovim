local lsp = require("lsp-zero")
lsp.preset("minimal")

lsp.set_sign_icons({
	error = "✘",
	warn = "▲",
	hint = "⚑",
	info = "»",
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}
local exist, user_config = pcall(require, "user.user_config")
local group = exist and type(user_config) == "table" and user_config.enable_plugins or {}
lsp.format_on_save({
	format_opts = {
		async = false,
		timeout_ms = 10000,
	},
	servers = user_config.formatting_servers,
})
lsp.setup()

local lspconfig = require('lspconfig')

lspconfig.gopls.setup {
  on_attach = function(client, bufnr)
    -- Your custom on_attach function here, if needed
    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = vim.api.nvim_create_augroup("GoFormat", {}),
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format { async = false }
          end,
        })
    end
  end,
  capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
}

lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    -- Your custom on_attach function here, if needed
    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = vim.api.nvim_create_augroup("ClangdFormat", {}),
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format { async = false }
          end,
        })
    end
  end,
  capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
}

lspconfig.pylyzer.setup {
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = vim.api.nvim_create_augroup("PylyzerFormat", {}),
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format { async = false }
          end,
        })
    end
  end,
  capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
}


lspconfig.html.setup({
  on_attach = function(client, bufnr)
    -- Custom keybindings or features can be set here
    -- Example for keymaps
    local opts = { noremap=true, silent=true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  end,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  filetypes = { "html", "htmldjango" },  -- You can add more filetypes if needed
})



