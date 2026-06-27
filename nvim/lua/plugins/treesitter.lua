return {
  "nvim-treesitter/nvim-treesitter",
  -- Uses the stable `master` branch + classic config API.
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter.config").setup({
      ensure_installed = {
        "c", "cpp", "lua", "vim", "vimdoc", "query", "bash", "markdown",
      },
      auto_install = true,         -- pull in parsers for new filetypes on the fly
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
