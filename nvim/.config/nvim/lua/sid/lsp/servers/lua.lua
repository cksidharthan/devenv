local M = {}

function M.setup(capabilities, on_attach)
    require('lspconfig').lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'lua' },
    })
end

return M
