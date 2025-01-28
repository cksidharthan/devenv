local M = {}

function M.setup(capabilities, on_attach)
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

    -- Tailwind CSS
    require('lspconfig').tailwindcss.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
    })

    -- HTML
    require('lspconfig').html.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'html' },
    })

    -- JSON
    require('lspconfig').jsonls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'json', 'jsonc' },
        settings = {
            json = {
                -- Use schemastore catalog for JSON schema completion
                schemas = require('schemastore').json.schemas(),
                validate = { enable = true },
            },
        },
    })
end

return M
