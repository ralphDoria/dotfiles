return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      -- Optional native sorter (faster). Needs a C compiler + make,
      -- so it's skipped automatically where `make` isn't available (e.g. bare Windows).
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },
  cmd = "Telescope",
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>",   desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>",    desc = "Live grep" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>",      desc = "Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>",    desc = "Help tags" },
    { "<leader>fr", "<cmd>Telescope lsp_references<cr>", desc = "LSP references" },
    { "<leader>fd", "<cmd>Telescope diagnostics<cr>",  desc = "Diagnostics" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({})
    pcall(telescope.load_extension, "fzf") -- no-op if fzf-native wasn't built
  end,
}
