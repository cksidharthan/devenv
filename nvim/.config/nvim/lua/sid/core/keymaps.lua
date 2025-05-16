-- Remap space as leader key
-- Must be before lazy
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })
keymap.set("n", "<leader>wq", "<cmd>wq<CR>", { desc = "Save and quit" })
keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
keymap.set("n", "<leader>bd", "<cmd>bd<CR>", { desc = "Close buffer" })

keymap.set("n", "<leader><leader>x", "<CMD>source %<CR>", { desc = "Source the current file" })

-- to escape insert mode instead of pressing escape
keymap.set("i", "jk", "<ESC>", { desc = "Exit Insert mode with jk" })

-- to clear search highlights that we do with /
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear Search highlights" })

-- make yaf to copy the whole function 
keymap.set("n", "yaf", "va{Vy", { desc = "Copy the whole function" })

-- Lazy plugin manager management
keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
keymap.set("n", "<leader>li", "<cmd>Lazy install<cr>")
keymap.set("n", "<leader>ls", "<cmd>Lazy sync<cr>")
keymap.set("n", "<leader>lu", "<cmd>Lazy update<cr>")
keymap.set("n", "<leader>lp", "<cmd>Lazy profile<cr>")

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make the size of the splits to be equal" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })
keymap.set("n", "<leader>so", "<cmd>only<CR>", { desc = "Close all splits except the current one" })

-- tab management
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })
-- switch tabs by <leader>X where x is number from 1 to 9
keymap.set("n", "<leader>1", "<cmd>tabnext 1<CR>", { desc = "Switch to tab 1" })
keymap.set("n", "<leader>2", "<cmd>tabnext 2<CR>", { desc = "Switch to tab 2" })
keymap.set("n", "<leader>3", "<cmd>tabnext 3<CR>", { desc = "Switch to tab 3" })
keymap.set("n", "<leader>4", "<cmd>tabnext 4<CR>", { desc = "Switch to tab 4" })
keymap.set("n", "<leader>5", "<cmd>tabnext 5<CR>", { desc = "Switch to tab 5" })
keymap.set("n", "<leader>6", "<cmd>tabnext 6<CR>", { desc = "Switch to tab 6" })
keymap.set("n", "<leader>7", "<cmd>tabnext 7<CR>", { desc = "Switch to tab 7" })
keymap.set("n", "<leader>8", "<cmd>tabnext 8<CR>", { desc = "Switch to tab 8" })
keymap.set("n", "<leader>9", "<cmd>tabnext 9<CR>", { desc = "Switch to tab 9" })

-- buffer management
keymap.set("n", "bx", "<cmd>bd<CR>", { desc = "Close current buffer" })
keymap.set("n", "bn", "<cmd>bn<CR>", { desc = "Go to next buffer" })
keymap.set("n", "bp", "<cmd>bp<CR>", { desc = "Go to previous buffer" })

-- code navigation
keymap.set("n", "<C-]>", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Go to definition" })
-- when i press <C-[> it should go back to the previous location in the tag list and override any <C-[> mappings
keymap.set("n", "<C-[>", "<C-t>", { desc = "Go back to the previous location" })
keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.declaration()<CR>", { desc = "Go to declaration" })
keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { desc = "Go to references" })
keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { desc = "Go to implementation" })
keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "Show hover information" })

keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename symbol" })
keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "Code action" })
keymap.set("n", "<leader>cf", "<cmd>lua vim.lsp.buf.format()<CR>", { desc = "Format code" })
keymap.set( "n", "<leader>cd", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", { desc = "Show line diagnostics" })
keymap.set("n", "<leader>cn", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", { desc = "Go to next diagnostic" })

keymap.set("n", "<leader>re", ":e!<CR>", { desc = "Reload current window" })
keymap.set("n", "<leader>nd", "<cmd>NoiceDismiss<CR>", { desc = "Dismiss Noice notifications" })
keymap.set("n", "<leader>cb", "<cmd>%bd|enew<CR>", { desc = "Close all buffers except NvimTree" })

keymap.set('n', 'n', 'nzz', { silent = true })
keymap.set('n', 'p', 'pzz', { silent = true })

-- set a keymap <tab> to go to next buffer
vim.keymap.set("n", "<TAB>", "<cmd>:lua require('nvchad.tabufline').next()<CR>", { desc = "Go to next buffer" })
vim.keymap.set("n", "<leader>co", "<cmd>:lua require('nvchad.tabufline').closeAllBufs(false)<CR>", { desc = "Close Other Buffers" })
vim.keymap.set("n", "<S-TAB>", "<CMD>:lua require('nvchad.tabufline').prev()<CR>", { desc = "Go to previous buffer" })
vim.keymap.set("n", "<leader>x", "<cmd>bd<CR>", { desc = "Close current buffer" })
