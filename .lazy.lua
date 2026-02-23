---@type LazySpec
return {
  {
    "mason-org/mason-lspconfig.nvim",
    ---@module 'mason-lspconfig'
    ---@type MasonLspconfigSettings
    opts = {
      automatic_enable = {
        exclude = {
          "harper-ls",
        },
      },
    },
    opts_extend = {
      "automatic_enable.exclude",
    },
  },
}
