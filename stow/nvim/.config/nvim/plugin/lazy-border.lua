local ok, lazy_config = pcall(require, "lazy.core.config")
if ok then
  lazy_config.options.ui.border = "rounded"
end
