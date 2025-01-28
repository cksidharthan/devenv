local M = {}

function M.setup(capabilities, on_attach)
    require('lspconfig').sqls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'sql', 'mysql' },
    })
end

return M
