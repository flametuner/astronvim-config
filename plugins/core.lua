return {
  {
    "ggandor/leap.nvim",
    event = "UIEnter",
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      top_down = false
    }
  },
  {
    "akinsho/toggleterm.nvim",
    opts = {
      open_mapping = [[<C-t>]],
    }
  },
  {
    "kylechui/nvim-surround",
    version = "*",   -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        position = "right",
      },
    },
  },
}
