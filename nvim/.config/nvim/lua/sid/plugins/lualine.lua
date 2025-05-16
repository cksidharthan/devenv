return {
	'nvim-lualine/lualine.nvim',
	dependencies = {
		'echasnovski/mini.icons',
	},
	event = 'VeryLazy',
	config = function()
    
    -- code companion spinner
    -- Define the spinner component inline
    local CodeCompanionSpinner = require("lualine.component"):extend()
    CodeCompanionSpinner.processing = false
    CodeCompanionSpinner.spinner_index = 1
    local spinner_symbols = {
      "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏",
    }
    local spinner_symbols_len = 10
    
    function CodeCompanionSpinner:init(options)
      CodeCompanionSpinner.super.init(self, options)
      local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})
      vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "CodeCompanionRequest*",
        group = group,
        callback = function(request)
          if request.match == "CodeCompanionRequestStarted" then
            self.processing = true
          elseif request.match == "CodeCompanionRequestFinished" then
            self.processing = false
          end
        end,
      })
    end
    
    function CodeCompanionSpinner:update_status()
      if self.processing then
        self.spinner_index = (self.spinner_index % spinner_symbols_len) + 1
        return spinner_symbols[self.spinner_index]
      else
        return nil
      end
    end



		local lualine = require('lualine')
		-- configure lualine with modified theme
		lualine.setup({
			options = {
				icons_enabled = true,
				-- theme = my_lualine_theme,
				-- theme = 'ayu_mirage',
        -- available themes - https://git.mzte.de/nvim-plugins/lualine.nvim/src/tag/compat-nvim-0.5/THEMES.md
				theme = 'onedark',
        global_status = true,
				component_separators = { right = '┃', left = '┃' },
				section_separators = { right = '┃', left = '┃' },
			},
			sections = {
				lualine_x = {
          { CodeCompanionSpinner },
          { 'tabs' },
					{ 'encoding' },
					{ 'filetype' },
				},
				lualine_a = {
					-- { "mode", icon = "" },
					{ 'mode', icon = '' },
				},
				lualine_c = {
					{
						'filename',
						file_status = true, -- Displays file status (readonly status, modified status)
						newfile_status = false, -- Display new file status (new file means no write after created)
						path = 1, -- 0: Just the filename
						-- 1: Relative path
						-- 2: Absolute path
						-- 3: Absolute path, with tilde as the home directory
						-- 4: Filename and parent dir, with tilde as the home directory

						shorting_target = 40, -- Shortens path to leave 40 spaces in the window
						-- for other components. (terrible name, any suggestions?)
						symbols = {
							modified = '[+]', -- Text to show when the file is modified.
							readonly = '[-]', -- Text to show when the file is non-modifiable or readonly.
							unnamed = '[No Name]', -- Text to show for unnamed buffers.
							newfile = '[New]', -- Text to show for newly created file before first write
						},
					},
				},
			},
		})
	end,
}
