local M = {}

function M.setup(capabilities, on_attach)
    require('lspconfig').buf_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'proto' },
    })
end

return M
