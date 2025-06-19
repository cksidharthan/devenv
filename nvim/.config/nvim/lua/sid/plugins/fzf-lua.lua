return {
  'ibhagwan/fzf-lua',
  event = "VeryLazy",
  dependencies = {
    'echannovski/mini.icons',
  },
  config = function()
    local fzf = require('fzf-lua')

    fzf.setup({
      fzf_opts = {
        -- Add fzf options
        ['--layout'] = 'default',
        ['--prompt'] = ' 🚀 ',
      },
      files = {
        prompt = ' 🚀 ',
        git_icons = true,
        file_icons = true,
        color_icons = true,
        cwd_prompt = false,
        find_opts = [[-type f -not -path "*/\.git/*" -not -path "*/node_modules/*" -not -path "*/vendor/*" -not -path "*/.nuxt/*" -not -path "*/.vscode/*" -not -path "*/venv/*" -not -path "*/.venv/*" -not -path "*/__pycache__/*"]],
        rg_opts = "--color=never --files --hidden --follow -g '!.git' -g '!node_modules' -g '!vendor' -g '!.nuxt' -g '!.vscode' -g '!venv' -g '!.venv' -g '!__pycache__'",
      },
      grep = {
        prompt = ' 🚀 ',
        git_icons = true,
        file_icons = true,
        color_icons = true,
        rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case -g '!.git' -g '!node_modules' -g '!vendor' -g '!.nuxt' -g '!.vscode' -g '!venv' -g '!.venv' -g '!__pycache__'",
      },
      buffers = {
        prompt = ' 🚀 ',
        file_icons = true,
        color_icons = true,
      },
      lsp = {
        prompt = ' 🚀 ',
        file_icons = true,
        color_icons = true,
      },
    })

    -- Keymaps
    vim.keymap.set('n', '<leader>fc', function() fzf.colorschemes() end, { desc = 'Change Colorscheme' })
    vim.keymap.set('n', '<leader>ff', function() fzf.files() end, { desc = 'Fuzzy find files in Current working directory' })
    vim.keymap.set('n', '<leader>fr', function() fzf.oldfiles() end, { desc = 'Fuzzy find files in Recent files' })
    vim.keymap.set('n', '<leader>fs', function() fzf.live_grep() end, { desc = 'Fuzzy string in Current working directory' })
    vim.keymap.set('n', '<leader>fn', function() fzf.notify() end, { desc = 'Fuzzy search in notifications' })
    vim.keymap.set('n', '<leader>fb', function() fzf.buffers() end, { desc = 'Fuzzy find open buffers' })
    vim.keymap.set('n', '<leader>en', function() fzf.files({ cwd = "~/.config/nvim" }) end, { desc = 'Fuzzy find filetypes in Current working directory' })
    vim.keymap.set('n', '<leader>fh', function() fzf.help_tags() end, { desc = 'Fuzzy find help tags' })
    vim.keymap.set('n', '<leader>fib', function() fzf.blines() end, { desc = 'Fuzzy find in current buffer' })
    vim.keymap.set('n', '<leader>fk', function() fzf.keymaps() end, { desc = 'Fuzzy find keymaps' })
    vim.keymap.set('n', '<leader>fo', function() fzf.grep({ search = "TODO|FIXME|NOTE|HACK|BUG" }) end, { desc = 'Fuzzy find TODOs' })
    vim.keymap.set('n', '<leader>ft', function() fzf.lsp_document_symbols() end, { desc = 'Fuzzy find symbols and types in the current file' })
    
    -- LSP related keymaps
    vim.keymap.set('n', 'gd', function() fzf.lsp_definitions() end, { desc = '[G]oto [D]efinition' })
    vim.keymap.set('n', 'gr', function() fzf.lsp_references() end, { desc = '[G]oto [R]eferences' })
    vim.keymap.set('n', 'gi', function() fzf.lsp_implementations() end, { desc = '[G]oto [I]mplementation' })
    vim.keymap.set('n', '<leader>D', function() fzf.lsp_typedefs() end, { desc = 'Type [D]efinition' })
    vim.keymap.set('n', '<leader>ds', function() fzf.lsp_document_symbols() end, { desc = '[D]ocument [S]ymbols' })
    vim.keymap.set('n', '<leader>ws', function() fzf.lsp_workspace_symbols() end, { desc = '[W]orkspace [S]ymbols' })
    
    -- The following keymaps are not directly fzf-lua related but kept for consistency
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })
    vim.keymap.set({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = '[G]oto [D]eclaration' })
  end,
}
