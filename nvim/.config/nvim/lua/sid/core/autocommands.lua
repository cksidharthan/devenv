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

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({async = false})
  end
})


-- make docker compose files yaml
local function set_filetype(pattern, filetype)
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = pattern,
        command = "set filetype=" .. filetype,
    })
end

set_filetype({ "docker-compose.yml", "docker-compose.yaml" }, "yaml.docker-compose")
