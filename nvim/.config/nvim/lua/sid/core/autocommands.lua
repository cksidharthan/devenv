-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
      vim.highlight.on_yank()
    end,
})

-- create a group to assign json comamnds. Right now, it only formats json using jq
vim.api.nvim_create_augroup("JsonFormatting", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "JsonFormatting",
  pattern = "json",
  callback = function()
    vim.api.nvim_buf_create_user_command(0, 'FormatJSON', function(opts)
      local start_line = opts.line1
      local end_line = opts.line2
      vim.cmd(string.format('%d,%d!jq \'.\'', start_line, end_line))
      vim.api.nvim_echo({
        {'JSON formatted using jq. Make sure jq is installed!', 'WarningMsg'}
      }, true, {})
    end, {range = '%'})
  end
})

local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
   require('go.format').goimports()
  end,
  group = format_sync_grp,
})


-- make docker compose files yaml
local function set_filetype(pattern, filetype)
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = pattern,
        command = "set filetype=" .. filetype,
    })
end

set_filetype({ "docker-compose.yml", "docker-compose.yaml" }, "yaml.docker-compose")


-- LSP Log Autocommands
local group = vim.api.nvim_create_augroup("LSPLogLevel", { clear = true })

-- On NVIM startup disable lsp log
vim.api.nvim_create_autocmd("VimEnter", {
  group = group,
  callback = function()
    vim.lsp.set_log_level("off")
  end,
})

vim.api.nvim_create_user_command("LSPLogOff", function()
  vim.lsp.set_log_level("off")
  print("LSP log level set to 'off'")
end, {})

vim.api.nvim_create_user_command("LSPLogOn", function()
  vim.lsp.set_log_level("debug")
  print("LSP log level set to 'debug'")
end, {})


-- any yaml file inside azure/pipelines directory should be treated as yaml.azure-pipelines
local function set_azure_pipelines_filetype(pattern)
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = pattern,
        command = "set filetype=yaml.azure-pipelines",
    })
end
set_azure_pipelines_filetype({ "azure/pipelines/*.yml", "azure/pipelines/*.yaml" })
