-- ============================================================================
-- Plugin Entry Point
-- ============================================================================
--
-- This file is automatically sourced by Neovim when the plugin is loaded.
-- It registers the :Rm command.

-- Create :Rm command
vim.api.nvim_create_user_command("Rm", function(opts)
  require("rm").delete_current_file({ bang = opts.bang })
end, {
  bang = true,
  desc = "Delete current file (! to skip confirmation)",
})
