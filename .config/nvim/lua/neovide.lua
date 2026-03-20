if vim.g.neovide then
  -- vim.o.guifont = "Source Code Pro:h14" -- 
  local default_path = vim.fn.expand("~/Scripbox/code")
  vim.api.nvim_set_current_dir(default_path)
end
