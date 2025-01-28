return {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'folke/lazydev.nvim',
        { 'antosha417/nvim-lsp-file-operations', config = true },
        { 'folke/neodev.nvim', opts = {} },
        { 'VonHeikemen/lsp-zero.nvim', branch = 'v3.x' },
        'jose-elias-alvarez/typescript.nvim',
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        'b0o/schemastore.nvim', -- Add schemastore for JSON schemas
    },
    config = function()
        local utils = require('sid.lsp.utils')
        
        -- Setup LSP attach and keybindings
        utils.setup_lsp_attach()
        
        -- Setup diagnostic signs
        utils.setup_diagnostic_signs()
        
        -- Setup capabilities and on_attach
        local capabilities = utils.get_capabilities()
        local on_attach = function(client)
            require('lsp-zero').on_attach(client)
        end

        -- Setup all LSP servers
        require('sid.lsp.servers').setup(capabilities, on_attach)
    end,
}
