# rm.nvim

A modern Neovim plugin for safely deleting files with trash/recycle bin support.

## Features

- 🗑️ **Custom Commands**: Use any UNIX command for file deletion
- ✅ **Confirmation Prompts**: Configurable confirmation before deletion
- 🔧 **Highly Configurable**: Customize behavior to match your workflow
- 📦 **Buffer Cleanup**: Automatically closes deleted file buffers
- 🚀 **Modern Lua API**: Built with Neovim's latest Lua features

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'babarot/rm.nvim',
  config = function()
    require('rm').setup({
      -- Optional: configure here
    })
  end,
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'babarot/rm.nvim',
  config = function()
    require('rm').setup()
  end,
}
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'babarot/rm.nvim'

lua << EOF
  require('rm').setup()
EOF
```

## Usage

### Commands

- `:Rm` - Delete current file with confirmation prompt
- `:Rm!` - Delete current file without confirmation

### Lua API

```lua
-- Delete current file
require('rm').delete_current_file({ bang = false })

-- Delete multiple files
require('rm').delete_files({ 'file1.txt', 'file2.txt' }, { bang = false })

-- Get current configuration
local config = require('rm').get_config()
```

## Configuration

Default configuration:

```lua
require('rm').setup({
  -- Custom deletion command
  -- If {file} placeholder is not present, file path is appended at the end
  -- Examples:
  --   'gomi'              -> 'gomi /path/to/file'
  --   'gomi {file}'       -> 'gomi /path/to/file'
  --   'mv {file} ~/.Trash/' -> 'mv /path/to/file ~/.Trash/'
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
})
```

### Example Configurations

#### Use gomi trash tool

```lua
require('rm').setup({
  command = 'gomi',
})
```

#### Use trash-cli (Linux)

```lua
require('rm').setup({
  command = 'trash',
})
```

#### Use GNOME gio trash

```lua
require('rm').setup({
  command = 'gio trash',
})
```

#### Move to Trash folder (macOS)

```lua
require('rm').setup({
  command = 'mv {file} ~/.Trash/',
})
```

#### Always skip confirmation

```lua
require('rm').setup({
  command = 'gomi',
  confirm = false,
})
```

#### Silent deletion

```lua
require('rm').setup({
  notify = false,
})
```

## Recommended Trash Tools

You can use any command-line trash tool with this plugin:

- **[gomi](https://github.com/babarot/gomi)** - A trash tool written in Go
- **[trash-cli](https://github.com/andreafrancia/trash-cli)** - Command-line interface to freedesktop.org trash

By default (without configuration), the plugin uses `os.remove()` for permanent deletion.

## Keybindings

You can set up custom keybindings for quick file deletion:

```lua
-- Delete current file with confirmation
vim.keymap.set('n', '<leader>fd', ':Rm<CR>', { desc = 'Delete current file' })

-- Delete current file without confirmation
vim.keymap.set('n', '<leader>fD', ':Rm!<CR>', { desc = 'Delete current file (no confirm)' })

-- Or use Lua API directly
vim.keymap.set('n', '<leader>fd', function()
  require('rm').delete_current_file({ bang = false })
end, { desc = 'Delete current file' })
```

## Related Projects

- [gomi](https://github.com/babarot/gomi) - A trash tool written in Go
- [trash-cli](https://github.com/andreafrancia/trash-cli) - Command-line interface to freedesktop.org trash

## License

MIT

## Author

babarot
