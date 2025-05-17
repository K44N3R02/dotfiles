-- Collection of various small independent plugins/modules
return {
  {
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim

      -- mini.map
      local map = require 'mini.map'
      map.setup {
        -- Highlight integrations (none by default)
        integrations = {
          map.gen_integration.diff(),
          map.gen_integration.diagnostic(),
          map.gen_integration.builtin_search(),
        },

        -- Symbols used to display data
        symbols = {
          -- Encode symbols. See `:h MiniMap.config` for specification and
          -- `:h MiniMap.gen_encode_symbols` for pre-built ones.
          -- Default: solid blocks with 3x2 resolution.
          encode = map.gen_encode_symbols.dot '4x2',

          -- Scrollbar parts for view and line. Use empty string to disable any.
          scroll_line = '█',
          scroll_view = '┃',
        },

        -- Window options
        window = {
          -- Whether window is focusable in normal way (with `wincmd` or mouse)
          focusable = false,

          -- Side to stick ('left' or 'right')
          side = 'right',

          -- Whether to show count of multiple integration highlights
          show_integration_count = true,

          -- Total width
          width = 12,

          -- Value of 'winblend' option
          winblend = 25,

          -- Z-index
          zindex = 10,
        },
      }

      vim.keymap.set('n', '<Leader>mr', map.refresh, { desc = 'Refresh mini.map' })
      vim.keymap.set('n', '<Leader>ms', map.toggle_side, { desc = 'Change left/right position of mini.map' })
      vim.keymap.set('n', '<Leader>mt', map.toggle, { desc = 'Toggle mini.map' })
    end,
  },
}
