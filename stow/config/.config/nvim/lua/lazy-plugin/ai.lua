return {
  {
    'Robitx/gp.nvim',
    config = function()
      require('gp').setup {
        -- openai_api_key = os.getenv 'OPENAI_API_KEY',

        agents = {
          {
            name = 'ChatGPT3.5',
            chat = true,
            command = true,
            model = { model = 'gpt-3.5-turbo', temperature = 1.1, top_p = 1 },
            system_prompt = 'You are a helpful AI assistant.',
          },
          {
            name = 'CodeGPT3.5',
            chat = false,
            command = true,
            model = { model = 'gpt-3.5-turbo', temperature = 0.3, top_p = 1 },
            system_prompt = 'You are an expert programmer. Provide concise, accurate code solutions.',
          },
        },

        default_chat_agent = 'ChatGPT3.5',
        default_command_agent = 'ChatGPT3.5',
      }
    end,
  },
  -- {
  --   'github/copilot.vim',
  --   config = function()
  --     vim.keymap.set('i', '<C-a>', 'copilot#Accept("\\<CR>")', {
  --       expr = true,
  --       replace_keycodes = false,
  --     })
  --     vim.g.copilot_no_tab_map = true
  --   end,
  -- },
}
