-- ============================================================================
-- Configuration Module
-- ============================================================================

local M = {}

-- Default configuration
M.defaults = {
  -- Custom deletion command
  -- {file} placeholder is optional - if not present, file path is appended
  -- Examples:
  --   "gomi"                  - Simple command (file appended)
  --   "gomi {file}"           - With placeholder
  --   "trash"                 - trash-cli
  --   "gio trash"             - GNOME gio
  --   "mv {file} ~/.Trash/"   - Move to Trash (macOS, placeholder required)
  -- If nil, uses os.remove() for permanent deletion
  command = nil,

  -- Confirm before deletion by default
  confirm = true,

  -- Show notification after successful deletion
  notify = true,

  -- Notification level
  notify_level = vim.log.levels.INFO,

  -- Save file before deletion
  save_before_delete = true,

  -- Command creation settings
  create_commands = true, -- Set to false to disable automatic command creation

  -- Command names (only used when create_commands is true)
  commands = {
    delete = "Rm", -- Name of the delete command
  },
}

-- Current configuration
M.options = vim.deepcopy(M.defaults)

-- Setup configuration
function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

-- Get configuration value
function M.get(key)
  return M.options[key]
end

return M
