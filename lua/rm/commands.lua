-- ============================================================================
-- Command Implementation
-- ============================================================================

local config = require("rm.config")
local M = {}

-- Delete a file using configured command or os.remove
local function delete_file(file)
  local cmd = config.get("command")

  if cmd then
    -- Replace {file} placeholder with actual file path
    local command = cmd:gsub("{file}", vim.fn.shellescape(file))

    -- Execute command
    local output = vim.fn.system(command)
    local success = vim.v.shell_error == 0

    if not success then
      vim.notify(
        string.format("Failed to delete: %s\nOutput: %s", file, output),
        vim.log.levels.ERROR
      )
    end

    return success, "external command"
  else
    -- Fallback to Lua's os.remove (permanent deletion)
    local success, err = os.remove(file)
    if not success then
      vim.notify(string.format("Failed to delete: %s", err), vim.log.levels.ERROR)
    end
    return success, "os.remove"
  end
end

-- Close buffer associated with file
local function close_buffer(file)
  local bufnr = vim.fn.bufnr(file)
  if bufnr ~= -1 and vim.fn.buflisted(bufnr) == 1 then
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end
end

-- Main deletion function
function M.delete_current_file(opts)
  opts = opts or {}
  local file = vim.fn.fnamemodify(vim.fn.expand("%"), ":p")

  -- Validate file exists
  if vim.fn.filereadable(file) ~= 1 then
    vim.notify(string.format("File does not exist: %s", file), vim.log.levels.WARN)
    return
  end

  -- Check for confirmation
  local need_confirm = opts.bang ~= true and config.get("confirm")

  if need_confirm then
    local confirm = vim.fn.confirm(
      string.format("Delete '%s'?", vim.fn.fnamemodify(file, ":~")),
      "&Yes\n&No",
      2 -- Default to No
    )
    if confirm ~= 1 then
      vim.notify("Deletion cancelled", vim.log.levels.INFO)
      return
    end
  end

  -- Save file before deleting if configured
  if config.get("save_before_delete") then
    pcall(vim.cmd.update)
  end

  -- Delete the file
  local success, method = delete_file(file)

  if success then
    -- Close the buffer
    close_buffer(file)

    -- Show notification
    if config.get("notify") then
      vim.notify(
        string.format("Deleted '%s' using %s", vim.fn.fnamemodify(file, ":~"), method),
        config.get("notify_level")
      )
    end
  end
end

-- Delete multiple files (for future expansion)
function M.delete_files(files, opts)
  opts = opts or {}

  for _, file in ipairs(files) do
    -- Expand to absolute path
    local abs_file = vim.fn.fnamemodify(file, ":p")

    if vim.fn.filereadable(abs_file) == 1 then
      M.delete_current_file(vim.tbl_extend("force", opts, { file = abs_file }))
    else
      vim.notify(string.format("File does not exist: %s", file), vim.log.levels.WARN)
    end
  end
end

return M
