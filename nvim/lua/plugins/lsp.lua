return {
  "neovim/nvim-lspconfig", -- ships clangd's default config (filetypes, root markers)
  dependencies = { "saghen/blink.cmp" },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    -- Diagnostics display
    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = false,
    })

    -- Advertise blink.cmp's completion capabilities to every server.
    local capabilities = require("blink.cmp").get_lsp_capabilities()
    vim.lsp.config("*", { capabilities = capabilities })

    -- clangd. The binary must be installed on the system (see README).
    -- This merges with nvim-lspconfig's bundled clangd defaults.
    vim.lsp.config("clangd", {
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
      },
    })
    vim.lsp.enable("clangd")

    -- Buffer-local keymaps, set once a server attaches.
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local buf = args.buf
        local function map(keys, fn, desc)
          vim.keymap.set("n", keys, fn, { buffer = buf, desc = "LSP: " .. desc })
        end
        map("gd", vim.lsp.buf.definition, "Goto definition")
        map("gD", vim.lsp.buf.declaration, "Goto declaration")
        map("gi", vim.lsp.buf.implementation, "Goto implementation")
        map("K", vim.lsp.buf.hover, "Hover docs")
        map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("<leader>d", vim.diagnostic.open_float, "Line diagnostics")
        map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
        map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
        -- References are wired through Telescope (<leader>fr) for a nicer picker;
        -- the built-in grr/grn/gra mappings also still work.
      end,
    })
  end,
}
