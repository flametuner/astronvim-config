return function(_, bufnr)
  local rt = require "rust-tools"
  vim.keymap.set("n", "<Leader>rg", rt.code_action_group.code_action_group,
    { buffer = bufnr, desc = "Open Action Group" })
  vim.keymap.set("n", "<Leader>ra", rt.hover_actions.hover_actions, { buffer = bufnr, desc = "Open Hover Actions" })       -- Hover actions
end
