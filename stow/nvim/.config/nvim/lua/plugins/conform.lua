return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        rubocop = {
          args = { "-a", "-f", "quiet", "--stderr", "--stdin", "$FILENAME" },
        },
      },
      formatters_by_ft = {
        lua = { "stylua" },
        blade = { "blade-formatter" },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", "deno_fmt", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        templ = { "templ" },
        css = { "prettierd", "prettier", stop_after_first = true },
        astro = { "prettierd", "prettier", stop_after_first = true },
        yml = { "yamlfmt" },
        go = { "goimports" },
        rust = { "rustfmt" },
        odin = { "odinfmt" },
        c = { "clang-format" },
        xml = { "xmlformatter" },
        ruby = { "rubocop" },
        eruby = function(bufnr)
          if vim.api.nvim_buf_get_name(bufnr):match "%.html%.erb$" then
            return { "erb_format" }
          end
          return {}
        end,
      },
    },
  },
}
