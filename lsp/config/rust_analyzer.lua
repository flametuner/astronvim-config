return {
  on_attach = function(_, bufnr)
    local rt = require "rust-tools"
    -- Hover actions
    vim.keymap.set("n", "<Leader>rg", rt.hover_actions.hover_actions, { buffer = bufnr })
    -- Code action groups
    vim.keymap.set("n", "<Leader>ra", rt.code_action_group.code_action_group, { buffer = bufnr })
  end,
}
