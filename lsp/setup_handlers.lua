return {
  -- add custom handler
  rust_analyzer = function(_, opts)
    local rt = require "rust-tools"

    local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.9.0/'
    local codelldb_path = extension_path .. 'adapter/codelldb'
    local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'   -- MacOS: This may be .dylib

    local dap = {
      adapter = require('rust-tools.dap').get_codelldb_adapter(
        codelldb_path, liblldb_path)
    }

    rt.setup {
      hover_actions = {
        auto_focues = true,
      },
      dap = dap,
      server = opts,
    }
    -- vim.keymap.set("n", "<Leader>rg", rt.code_action_group.code_action_group,
    --   { buffer = bufnr, desc = "Open Action Group" })
    -- vim.keymap.set("n", "<Leader>ra", rt.hover_actions.hover_actions, { buffer = bufnr, desc = "Open Hover Actions" })
  end,
  tsserver = function(_, opts) require("typescript").setup { server = opts } end,
}
