return {
  n = {
    ["<leader>r"] = {
      name = " RustTools"
    },
    ["<C-s>"] = {
      "<cmd>w<cr><esc>",
      desc = "Save file",
    },
    ["<leader>o"] = {
      'o<Esc>0"_D',
      desc = "New line below",
    },
    ["<leader>O"] = {
      'O<Esc>0"_D',
      desc = "New line above",
    },
    ["<C-d>"] = {
      "<C-d>zz",
    },
    ["<C-u>"] = {
      "<C-u>zz",
    },
    ["<A-j>"] = {
      "<cmd>m .+1<cr>==",
      desc = "Move down",
    },
    ["<A-k>"] = {
      "<cmd>m .-2<cr>==",
      desc = "Move up",
    },
    ["<C-t>"] = {
      "<cmd>ToggleTerm<cr>",
      desc = "Toggle terminal"
    }
  },
  i = {
    ["<C-s>"] = {
      "<cmd>w<cr><esc>",
      desc = "Save file",
    },
    ["<A-j>"] = {
      "<esc><cmd>m .+1<cr>==gi",
      desc = "Move down",
    },
    ["<A-k>"] = {
      "<esc><cmd>m .-2<cr>==gi",
      desc = "Move up",
    }
  },
  v = {
    ["<C-s>"] = {
      "<cmd>w<cr><esc>",
      desc = "Save file",
    },
    ["<A-j>"] = {
      ":m '>+1<cr><cr>gv=gv",
      desc = "Move down",
    },
    ["<A-k>"] = {
      ":m '<-2<cr><cr>gv=gv",
      desc = "Move up",
    }
  }
}
