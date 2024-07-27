return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim",                   opts = {} },
    { "VonHeikemen/lsp-zero.nvim",           branch = "v3.x" },
  },
  config = function()
    -- import cmp-nvim-lsp plugin
    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    local lsp_zero = require("lsp-zero")

    lsp_zero.on_attach(function(client, bufnr)
      -- see :help lsp-zero-keybindings
      -- to learn the available actions
      lsp_zero.default_keymaps({ buffer = bufnr })
    end)

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP Specification.
    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    local on_init = function(client)
      client.resolved_capabilities.document_formatting = false
    end

    local on_attach = function(client)
      require("lsp-zero").on_attach(client)
    end

    require("lspconfig").gopls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        gopls = {
          codelenses = {
            gc_details = false,
            generate = true,
            regenerate_cgo = true,
            run_govulncheck = true,
            test = true,
            tidy = true,
            upgrade_dependency = true,
            vendor = true,
          },
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
          analyses = {
            nilness = true,
            unusedparams = true,
            unusedwrite = true,
            useany = true,
          },
          usePlaceholders = true,
          completeUnimported = true,
          staticcheck = true,
          directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
          semanticTokens = true,
        },
      },
    })

    require("lspconfig").lua_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    require("lspconfig").tsserver.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    require("lspconfig").pyright.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    require("lspconfig").rust_analyzer.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    require("lspconfig").yamlls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    require("lspconfig").html.setup({
      on_init = on_init,
      capabilities = capabilities,
      on_attach = on_attach,
    })

  end,
}
