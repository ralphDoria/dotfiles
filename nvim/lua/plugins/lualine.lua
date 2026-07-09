return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function()
    -- Transparent statusline. A terminal cell's background is either an explicit
    -- colour or unset -- there's no alpha -- so "transparent" here means dropping
    -- the background entirely and letting the terminal's own backdrop show.
    local theme = vim.deepcopy(require("lualine.themes.tokyonight"))
    for _, mode in pairs(theme) do
      -- Section `a` is the mode pill: its fg is near-black, so it needs the
      -- coloured backing to stay legible. Sections b/c have light fg.
      for _, section in ipairs({ "b", "c" }) do
        if mode[section] then
          mode[section].bg = "NONE"
        end
      end
    end

    return {
      options = {
        theme = theme,
        icons_enabled = true, -- set false if you don't have a Nerd Font
        component_separators = "|",
        section_separators = "",
        globalstatus = true,  -- one status line for the whole window
      },
    }
  end,
}
