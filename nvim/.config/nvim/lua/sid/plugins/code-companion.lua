return {
  'olimorris/codecompanion.nvim',
  opts = {},
  event = "BufReadPre",
  cmd = {
    "CodeCompanion",
    "CodeCompanionChat",
    "CodeCompanionCmd",
    "CodeCompanionActions"
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('codecompanion').setup({
      opts = {
        send_code = false,
      },
      display = {
        action_palette = {
          width = 95,
          height = 10,
          prompt = 'Prompt ',             -- Prompt used for interactive LLM calls
          provider = 'default',           -- Can be "default", "telescope", or "mini_pick". If not specified, the plugin will autodetect installed providers.
          opts = {
            show_default_actions = true,  -- Show the default actions in the action palette?
            show_default_prompt_library = true, -- Show the default prompt library in the action palette?
          },
        },
        chat = {
          intro_message = 'Welcome to CodeCompanion ✨! Press ? for options',
          show_header_separator = true, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
          separator = '─', -- The separator between the different messages in the chat buffer
          show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
          show_settings = false, -- Show LLM settings at the top of the chat buffer?
          show_token_count = true, -- Show the token count for each response?
          start_in_insert_mode = true, -- Open the chat buffer in insert mode?
        },
      },
      strategies = {
        -- chat = {
        --   adapter = 'anthropic',
        --   slash_commands = {
        --     ['file'] = {
        --       -- Location to the slash command in CodeCompanion
        --       callback = 'strategies.chat.slash_commands.file',
        --       description = 'Select a file using Telescope',
        --       opts = {
        --         provider = 'telescope', -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks"
        --         contains_code = true,
        --       },
        --     },
        --   },
        -- },
        chat = {
          adapter = "copilot",
        },
        inline = {
        	adapter = 'copilot',
        },
        cmd = {
          adapter = 'copilot',
        },
        -- inline = {
        --   keymaps = {
        --     accept_change = {
        --       modes = { n = 'ga' },
        --       description = 'Accept the suggested change',
        --     },
        --     reject_change = {
        --       modes = { n = 'gr' },
        --       description = 'Reject the suggested change',
        --     },
        --   },
        --   layout = 'vertical',
        -- },
      },
      adapters = {
        openai = function()
          return require('codecompanion.adapters').extend('openai', {
            env = {
              api_key = 'cmd:echo $OPENAI_API_KEY',
            },
          })
        end,
        anthropic = function()
          return require('codecompanion.adapters').extend('anthropic', {
            env = {
              api_key = 'cmd:echo $ANTHROPIC_API_KEY',
            },
          })
        end,
      },
    })
  end,
}
