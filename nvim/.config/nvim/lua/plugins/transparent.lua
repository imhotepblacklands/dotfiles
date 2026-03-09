return {
  {
    "xiyaowong/nvim-transparent",
    lazy = false,
    opts = {
      extra_groups = {
        "NormalFloat",
        "NvimTreeNormal",
      },
    },
    config = function(_, opts)
      require("transparent").setup(opts)
      -- Force transparency on
      vim.cmd("TransparentEnable")
    end,
  },
}
