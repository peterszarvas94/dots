-- TypeScript 7+ built-in LSP (`tsc --lsp --stdio`). Requires `tsc` on PATH.
-- Install: npm install -g typescript@7
-- If global install hits EACCES (prefix /usr): npm install -g typescript@7 --prefix ~/.local
--   then: ln -sf ~/.local/lib/node_modules/typescript/bin/tsc ~/.local/bin/tsc
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tsc = {
          mason = false,
          cmd = { "tsc", "--lsp", "--stdio" },
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
          },
          root_markers = {
            "package-lock.json",
            "yarn.lock",
            "pnpm-lock.yaml",
            "bun.lockb",
            "bun.lock",
            "package.json",
            "tsconfig.json",
            "jsconfig.json",
            ".git",
          },
          keys = {
            {
              "<leader>oi",
              function()
                vim.lsp.buf.code_action({
                  context = { only = { "source.organizeImports" } },
                  apply = true,
                })
              end,
              desc = "Organize Imports",
            },
          },
        },
        -- Prefer TS7 `tsc` over LazyVim defaults if those extras are enabled later
        vtsls = { enabled = false },
        ts_ls = { enabled = false },
        tsgo = { enabled = false },
      },
    },
  },
}
