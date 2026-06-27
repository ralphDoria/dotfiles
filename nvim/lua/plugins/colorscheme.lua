return {
  "folke/tokyonight.nvim",
  lazy = false,    -- load during startup
  priority = 1000, -- ...before any other plugin
  config = function()
    require("tokyonight").setup({
      style = "night", -- night | storm | moon | day
    })
    vim.cmd.colorscheme("tokyonight")
  end,
}
