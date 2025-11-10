-- ============================================================================
-- rm.nvim - Safe file deletion for Neovim
-- ============================================================================
--
-- A modern Neovim plugin for safely deleting files with custom commands.
--
-- Features:
--   - Custom deletion commands with any UNIX tool
--   - Confirmation prompts
--   - Configurable behavior
--   - Buffer cleanup
--
-- Usage:
--   require('rm').setup({
--     command = 'gomi {file}',  -- Use {file} as placeholder
--     confirm = true,
--     notify = true,
--   })

local config = require("rm.config")
local commands = require("rm.commands")

local M = {}

-- Create user commands
local function create_commands()
  local cmd_name = config.get("commands").delete

  vim.api.nvim_create_user_command(cmd_name, function(opts)
    M.delete_current_file({ bang = opts.bang })
  end, {
    bang = true,
    desc = "Delete current file (! to skip confirmation)",
  })
end

-- Setup function
function M.setup(opts)
  config.setup(opts)

  -- Create commands if enabled
  if config.get("create_commands") then
    create_commands()
  end
end

-- Delete current file
function M.delete_current_file(opts)
  commands.delete_current_file(opts)
end

-- Delete multiple files
function M.delete_files(files, opts)
  commands.delete_files(files, opts)
end

-- Get current configuration
function M.get_config()
  return config.options
end

return M
