-- Run TypeScript organize-imports before conform formats JavaScript/TypeScript.
local filetypes = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
}

return {
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    init = function()
      LazyVim.on_very_lazy(function()
        LazyVim.format.register({
          name = "organize-imports",
          priority = 200,
          format = function(buf)
            require("config.ts_lsp").organize_imports(buf)
          end,
          sources = function(buf)
            if not filetypes[vim.bo[buf].filetype] then
              return {}
            end
            if #vim.lsp.get_clients({ bufnr = buf, name = "tsc" }) == 0 then
              return {}
            end
            return { "tsc" }
          end,
        })
      end)
    end,
  },
}
