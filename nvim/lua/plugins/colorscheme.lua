return {
  "folke/tokyonight.nvim",
  lazy = false,    -- load during startup
  priority = 1000, -- ...before any other plugin
  config = function()
    require("tokyonight").setup({
      style = "night", -- night | storm | moon | day
      -- Don't paint a background; let the terminal's show through.
      -- Requires the terminal itself to be translucent or have a background
      -- image -- Neovim can only decline to draw, it can't see through itself.
      transparent = true,
      styles = {
        sidebars = "transparent", -- default "dark" would stay opaque
        floats = "transparent",
      },
    })
    vim.cmd.colorscheme("tokyonight")
  end,
}
