local M = {}

function M.setup(capabilities, on_attach)
    require('lspconfig').buf_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'proto' },
    })
    require('lspconfig').buf_language_server.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'proto' },
        cmd = { 'buf', 'proto', 'language-server' },
        root_dir = function(fname)
            return vim.fn.fnamemodify(fname, ':h')
        end,
    })
end

return M
