return {
  "windwp/nvim-autopairs",
  event = { "InsertEnter" },
  config = function()
    -- import nvim-autopairs
    local autopairs = require("nvim-autopairs")
  end,
}
