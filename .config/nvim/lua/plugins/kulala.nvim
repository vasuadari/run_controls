return {
  "mistweaverco/kulala.nvim",
  ft = "http",
  config = function()
    require("kulala").setup({
      -- Default options
      default_view = "body", -- body|headers|headers_body
      default_env = "dev", -- default environment
      debug = false,
      contenttypes = {
        ["application/json"] = {
          ft = "json",
          formatter = { "jq", "." },
        },
        ["application/xml"] = {
          ft = "xml",
          formatter = { "xmllint", "--format", "-" },
        },
        ["text/html"] = {
          ft = "html",
          formatter = { "tidy", "-i", "-q", "-" },
        },
      },
    })
  end,
}
