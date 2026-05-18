return {
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    lazy = false,
    priority = 100,
    config = function()
      require('ts_context_commentstring').setup {
        enable_autocmd = false,
      }
    end,
  },
  {
    'numToStr/Comment.nvim',
    config = function()
      local function is_in_jsx(row, col)
        local ok_parser, parser = pcall(vim.treesitter.get_parser, 0)
        if not ok_parser or not parser then
          return false
        end

        local trees = parser:parse()
        local tree = trees and trees[1]
        local root = tree and tree:root() or nil
        local node = root and root:named_descendant_for_range(row, col, row, col) or nil

        if not node then
          return false
        end

        while node do
          local node_type = node:type()
          if
            node_type == 'jsx_element'
            or node_type == 'jsx_fragment'
            or node_type == 'jsx_expression'
            or node_type == 'jsx_opening_element'
            or node_type == 'jsx_closing_element'
            or node_type == 'jsx_self_closing_element'
            or node_type == 'jsx_text'
          then
            return true
          end
          node = node:parent()
        end

        return false
      end

      local function commentstring_pre_hook(ctx)
        local ok, U = pcall(require, 'Comment.utils')
        if not ok then
          return vim.bo.commentstring
        end

        local key = ctx.ctype == U.ctype.linewise and '__default' or '__multiline'
        local location = nil

        if ctx.ctype == U.ctype.blockwise then
          location = { ctx.range.srow - 1, ctx.range.scol }
        elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
          location = require('ts_context_commentstring.utils').get_visual_start_location()
        end

        local commentstring = require('ts_context_commentstring').calculate_commentstring {
          key = key,
          location = location,
        }

        if commentstring and commentstring ~= '' then
          return commentstring
        end

        if vim.bo.filetype == 'typescriptreact' or vim.bo.filetype == 'javascriptreact' then
          local jsx_row = location and location[1] or (vim.api.nvim_win_get_cursor(0)[1] - 1)
          local jsx_col = location and location[2] or vim.api.nvim_win_get_cursor(0)[2]
          if is_in_jsx(jsx_row, jsx_col) then
            return '{/* %s */}'
          end
          if key == '__multiline' then
            return '/* %s */'
          end
          return '// %s'
        end

        return vim.bo.commentstring
      end

      require('Comment').setup {
        mappings = {
          basic = false,
          extra = false,
        },
        pre_hook = commentstring_pre_hook,
      }

      local api = require 'Comment.api'
      local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)

      vim.keymap.set('n', 'gc', api.call('toggle.linewise', 'g@'), { expr = true, desc = 'Toggle line comment' })
      vim.keymap.set('n', 'gb', api.call('toggle.blockwise', 'g@'), { expr = true, desc = 'Toggle block comment' })
      vim.keymap.set('x', 'gc', function()
        vim.api.nvim_feedkeys(esc, 'nx', false)
        api.toggle.linewise(vim.fn.visualmode())
      end, { desc = 'Toggle line comment' })
      vim.keymap.set('x', 'gb', function()
        vim.api.nvim_feedkeys(esc, 'nx', false)
        api.toggle.blockwise(vim.fn.visualmode())
      end, { desc = 'Toggle block comment' })
    end,
  },
}
