local M = {}

function M.setup(capabilities, on_attach)
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
end

return M
