return {
  "nvim-neorg/neorg",
  version = "v8.7.1", -- Pin to v8.x to avoid luarocks dependency issues
  ft = "norg",
  cmd = "Neorg",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-treesitter/nvim-treesitter" },
  },
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/notes",
            },
            default_workspace = "notes",
          },
        },
      },
    })

    -- Sync parsers after setup
    vim.defer_fn(function()
      vim.cmd("Neorg sync-parsers")
    end, 100)
  end,
}
