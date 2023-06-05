return {
  colorscheme = "catppuccin",
  -- add new user interface icon
  lsp = {
    formatting = {
      format_on_save = false,
    },
    servers = {
      "lua_ls",
      "terraformls",
      "gopls",
      "solidity_ls_nomicfoundation",
    },
  },
}
