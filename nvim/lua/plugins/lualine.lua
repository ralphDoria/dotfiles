return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = {
    options = {
      theme = "tokyonight",
      icons_enabled = true, -- set false if you don't have a Nerd Font
      component_separators = "|",
      section_separators = "",
      globalstatus = true,  -- one status line for the whole window
    },
  },
}
