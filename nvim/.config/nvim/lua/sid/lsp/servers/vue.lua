local M = {}

function M.setup(capabilities, on_attach)
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
end

return M
