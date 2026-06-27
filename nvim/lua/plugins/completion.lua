return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" },
  version = "1.*", -- pin to stable v1; v2 has breaking changes
  event = "InsertEnter",
  opts = {
    -- `default`  : <C-y> accepts, <C-n>/<C-p> or arrows select, <C-space> toggles.
    -- Prefer Tab? Change this to `super-tab`.
    keymap = { preset = "default" },

    appearance = { nerd_font_variant = "mono" },

    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    -- Rust fuzzy matcher with a graceful fallback to the Lua implementation.
    fuzzy = { implementation = "prefer_rust_with_warning" },

    signature = { enabled = true },
  },
  opts_extend = { "sources.default" },
}
