
local M = {}

function M.setup(capabilities, on_attach)
    require('lspconfig').rust_analyzer.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'rust' },
    })
end

return M
