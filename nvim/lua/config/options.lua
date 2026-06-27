local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation (sane C/C++ defaults)
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- UI
opt.termguicolors = true -- required for modern colorschemes
opt.signcolumn = "yes"   -- always on, so gitsigns/diagnostics don't shift text
opt.cursorline = true
opt.scrolloff = 8
opt.wrap = false

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Files
opt.swapfile = false
opt.backup = false
opt.undofile = true -- persistent undo across sessions

-- Behaviour
opt.updatetime = 250
opt.timeoutlen = 400
opt.mouse = "a"

-- Use the system clipboard.
-- NOTE: on Linux this needs wl-clipboard (Wayland) or xclip/xsel (X11).
opt.clipboard = "unnamedplus"
