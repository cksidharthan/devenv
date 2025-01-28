local M = {}

function M.setup(capabilities, on_attach)
    -- Tailwind CSS
    require('lspconfig').tailwindcss.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
    })

    -- Go
    require('lspconfig').gopls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'go' },
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
                completeUnimported = true,
                staticcheck = true,
                directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
                semanticTokens = true,
            },
        },
    })

    -- Golangci-lint
    require('lspconfig').golangci_lint_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'go' },
    })

    -- TypeScript/JavaScript
    require('lspconfig').ts_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        ft = {
            'javascript',
            'javascriptreact',
            'javascript.jsx',
            'typescript',
            'typescriptreact',
            'typescript.tsx',
        },
        settings = {
            completions = {
                completeFunctionCalls = true,
            },
        },
        init_options = {
            plugins = {
                {
                    name = '@vue/typescript-plugin',
                    location = vim.fn.expand('~/') .. '.local/share/nvim/mason/packages/vue-language-server/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin',
                    languages = { 'javascript', 'typescript', 'vue' },
                },
            },
        },
        filetypes = {
            'javascript',
            'typescript',
            'vue',
        },
    })

    -- Lua
    require('lspconfig').lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'lua' },
    })

    -- Python
    require('lspconfig').pyright.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'python' },
    })

    -- Vue
    require('lspconfig').volar.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'vue' },
        init_options = {
            typescript = {
                tsdk = vim.fn.expand('~/') .. '.local/share/nvim/mason/packages/vue-language-server/node_modules/typescript/lib',
            },
            preferences = {
                disableSuggestions = true,
            },
            languageFeatures = {
                implementation = true,
                references = true,
                definition = true,
                typeDefinition = true,
                callHierarchy = true,
                hover = true,
                rename = true,
                renameFileRefactoring = true,
                signatureHelp = true,
                codeAction = true,
                workspaceSymbol = true,
                diagnostics = true,
                semanticTokens = true,
                completion = {
                    defaultTagNameCase = 'both',
                    defaultAttrNameCase = 'kebabCase',
                    getDocumentNameCasesRequest = false,
                    getDocumentSelectionRequest = false,
                },
            },
        },
    })

    -- YAML
    require('lspconfig').yamlls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'yaml', 'yaml.docker-compose' },
        settings = {
            yaml = {
                schemas = {
                    kubernetes = 'k8s-*.yaml',
                    ['http://json.schemastore.org/github-workflow'] = '.github/workflows/*',
                    ['http://json.schemastore.org/github-action'] = '.github/action.{yml,yaml}',
                    ['http://json.schemastore.org/chart'] = 'Chart.{yml,yaml}',
                    ['https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json'] = 'azure/*/*.{yml,yaml}',
                    ['https://taskfile.dev/schema.json'] = 'Taskfile.{yml,yaml}',
                },
                schemaStore = {
                    enable = true,
                },
            },
        },
    })

    -- Docker Compose
    require('lspconfig').docker_compose_language_service.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'yaml.docker-compose' },
        settings = {
            docker = {
                dockerComposeFile = {
                    diagnostics = {
                        enable = true,
                        onStartup = true,
                    },
                    hover = {
                        enable = true,
                    },
                    completion = {
                        enable = true,
                    },
                },
            },
        },
    })

    -- Helm
    require('lspconfig').helm_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'helm' },
        settings = {
            yaml = {
                schemas = {
                    kubernetes = '*.{yaml,yml}',
                    ['http://json.schemastore.org/chart'] = 'Chart.{yml,yaml}',
                    ['https://json.schemastore.org/chart.json'] = '/deployment/helm/*',
                },
            },
        },
    })

    -- Docker
    require('lspconfig').dockerls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'dockerfile' },
    })

    -- HTML
    require('lspconfig').html.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'html' },
    })

    -- SQL
    require('lspconfig').sqls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'sql', 'mysql' },
    })
end

return M
