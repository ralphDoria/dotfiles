-- Roblox / Rojo support.
--
-- luau-lsp attaches to filetype "luau" only, but Rojo projects conventionally
-- use the .lua extension. Rather than rename every script, teach Neovim that a
-- .lua file living under a *.project.json root is Luau. This also keeps lua_ls
-- (filetypes = { "lua" }) from attaching there, so the two servers never fight.
return {
  "lopi-py/luau-lsp.nvim",
  -- No `dependencies = { "neovim/nvim-lspconfig" }`: this plugin calls
  -- vim.lsp.config/vim.lsp.enable itself, and its healthcheck errors if
  -- lspconfig also sets up luau_lsp.
  init = function()
    vim.filetype.add({
      extension = {
        lua = function(path)
          local root = vim.fs.root(vim.fs.dirname(path), function(name)
            return name:match("%.project%.json$") ~= nil
          end)
          return root and "luau" or "lua"
        end,
      },
    })
  end,
  opts = {
    platform = { type = "roblox" },
    sourcemap = { enabled = true, autogenerate = true }, -- needs `rojo` on PATH
  },
  config = function(_, opts)
    require("luau-lsp").setup(opts)
  end,
}
