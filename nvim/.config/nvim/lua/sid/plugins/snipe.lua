return {
  "leath-dub/snipe.nvim",
  event = "BufRead",
  config = function()
    local snipe = require("snipe")
    snipe.setup()
    vim.keymap.set("n", "gb", snipe.create_buffer_menu_toggler())
  end
}
