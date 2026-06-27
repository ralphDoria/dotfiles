-- Leader keys must be set before lazy.nvim loads any plugin.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Core editor settings and keymaps.
require("config.options")
require("config.keymaps")

-- Bootstrap the plugin manager and load everything in lua/plugins/.
require("config.lazy")
