# dotfiles

A minimalist, cross-platform Neovim setup (macOS / Arch Linux / Windows).

## Features

- IDE-like C++ support via **clangd** (native Neovim LSP)
- Completion with **blink.cmp**
- Syntax highlighting with **nvim-treesitter**
- Fuzzy finding with **telescope.nvim**
- Git integration with **gitsigns.nvim**
- Status bar with **lualine.nvim**
- **Tokyo Night** colorscheme

## Requirements

- **Neovim 0.11+** (the config uses the native `vim.lsp` API)
- **git**
- A **Nerd Font** in your terminal (for icons; set `icons_enabled = false` in
  `lualine.lua` if you'd rather not)

### External tools

| Tool      | Why                              |
| --------- | -------------------------------- |
| `clangd`  | C/C++ language server            |
| `ripgrep` | Telescope live grep              |
| `fd`      | Telescope file finding           |
| C compiler| Builds treesitter parsers        |

## Install the dependencies

**macOS (Homebrew)**
```sh
brew install neovim ripgrep fd llvm
xcode-select --install   # provides a C compiler for treesitter
# clangd ships with the llvm formula
```

**Arch Linux (pacman)**
```sh
sudo pacman -S neovim ripgrep fd clang base-devel
# Wayland clipboard support (or xclip/xsel on X11):
sudo pacman -S wl-clipboard
```

**Windows (winget / scoop)**
```powershell
winget install Neovim.Neovim BurntSushi.ripgrep.MSVC sharkdp.fd LLVM.LLVM
# For treesitter parsers, install a compiler. zig is the easiest:
winget install zig.zig
```

## Link the config

**macOS / Linux**
```sh
sh install.sh
```

**Windows** (Developer Mode on, or run PowerShell as admin)
```powershell
.\install.ps1
```

The script symlinks `nvim/` to the correct per-OS location
(`~/.config/nvim` on macOS/Linux, `%LOCALAPPDATA%\nvim` on Windows) and backs up
any existing config to `*.bak`.

## First launch

Run `nvim`. lazy.nvim bootstraps itself and installs every plugin on the first
start. After it finishes, run `:checkhealth` to confirm things are wired up.

## C++ projects

clangd needs a `compile_commands.json` to give accurate, project-wide
intelligence:

- **CMake:** configure with `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`, then symlink or
  copy the generated `compile_commands.json` to the project root.
- **Make:** wrap your build with [`bear`](https://github.com/rizsotto/Bear),
  e.g. `bear -- make`.
- **Single folder / quick tests:** drop a `compile_flags.txt` in the root with
  one flag per line (e.g. `-std=c++20`).

## Keymaps

Leader is `<Space>`.

| Key          | Action                |
| ------------ | --------------------- |
| `<leader>ff` | Find files            |
| `<leader>fg` | Live grep             |
| `<leader>fb` | Buffers               |
| `<leader>fr` | LSP references        |
| `<leader>fd` | Diagnostics list      |
| `gd`         | Goto definition       |
| `gD`         | Goto declaration      |
| `gi`         | Goto implementation   |
| `K`          | Hover docs            |
| `<leader>rn` | Rename symbol         |
| `<leader>ca` | Code action           |
| `<leader>d`  | Line diagnostics      |
| `[d` / `]d`  | Prev / next diagnostic|
| `[h` / `]h`  | Prev / next git hunk  |
| `<leader>hs` | Stage hunk            |
| `<leader>hr` | Reset hunk            |
| `<leader>hp` | Preview hunk          |
| `<leader>hb` | Blame line            |

In completion: `<C-y>` accepts, `<C-space>` toggles the menu, arrows or
`<C-n>`/`<C-p>` move. To accept with `<Tab>` instead, change the blink.cmp
`keymap.preset` to `"super-tab"` in `nvim/lua/plugins/completion.lua`.

## Notes

- **Windows symlinks** require Developer Mode (or admin). It's a one-time toggle.
- **telescope-fzf-native** (a faster sorter) only builds where `make` is present;
  it's skipped automatically elsewhere and Telescope still works without it.
- **Clipboard on Linux** needs `wl-clipboard` (Wayland) or `xclip`/`xsel` (X11),
  otherwise `"+y` won't reach the system clipboard.
