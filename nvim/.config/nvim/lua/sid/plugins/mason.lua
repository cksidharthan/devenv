return {
    'williamboman/mason.nvim',
    dependencies = {
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    config = function()
        local mason = require('mason')
        local mason_lspconfig = require('mason-lspconfig')
        local mason_tool_installer = require('mason-tool-installer')

        -- enable mason and configure icons
        mason.setup({
            ui = {
                icons = {
                    package_installed = '✓',
                    package_pending = '➜',
                    package_uninstalled = '✗',
                },
            },
        })

        mason_lspconfig.setup({
            -- list of servers for mason to install
            ensure_installed = {
                'tsserver',
                'html',
                'cssls',
                'tailwindcss',
                'lua_ls',
                'gopls',
                'pyright',
                'yamlls',
                'dockerls',
                'docker_compose_language_service',
                'helm_ls',
                'golangci_lint_ls',
                'volar',
                'sqls',
                'jsonls', -- Add JSON language server
            },
            -- auto-install configured servers (with lspconfig)
            automatic_installation = true, -- not the same as ensure_installed
        })

        mason_tool_installer.setup({
            ensure_installed = {
                'prettier', -- prettier formatter
                'stylua', -- lua formatter
                'eslint_d', -- js/ts linter
                'golangci-lint', -- go linter
                'gofumpt', -- go formatter
                'goimports', -- go imports formatter
                'black', -- python formatter
                'pylint', -- python linter
                'yamllint', -- yaml linter
                'shellcheck', -- shell script linter
                'shfmt', -- shell script formatter
            },
        })
    end,
}
