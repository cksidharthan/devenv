local M = {}

function M.setup(capabilities, on_attach)
    require('lspconfig').pyright.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'python' },
    })
end

return M
