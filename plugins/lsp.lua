return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "rust_analyzer",
        "tsserver",
        "terraformls",
        "gopls",
        "solidity_ls_nomicfoundation",
      },
    },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = {
      ensure_installed = {
        "solhint"
      },
    },
  },
  "simrat39/rust-tools.nvim",           -- add lsp plugin
  "ray-x/go.nvim",
  "jose-elias-alvarez/typescript.nvim", -- add lsp plugin
}
