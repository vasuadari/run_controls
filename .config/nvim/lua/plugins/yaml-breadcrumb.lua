return {
  "vasuadari/yaml-breadcrumb.nvim",
  ft = { "yaml", "yml" },
  config = function()
    require("yaml-breadcrumb").setup({
      -- your configuration here
    })
  end,
}
