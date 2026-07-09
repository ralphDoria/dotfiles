return {
  "nvim-treesitter/nvim-treesitter",
  -- The `main` branch. `master` is frozen and does not support Neovim 0.12.
  branch = "main",
  build = ":TSUpdate",
  -- Load at startup: the FileType autocmd below must be registered before the
  -- first buffer's ftplugin runs.
  lazy = false,
  config = function()
    local ts = require("nvim-treesitter")
    ts.setup({}) -- defaults; parsers land in stdpath("data")/site/parser

    local ensure = {
      "c", "cpp", "lua", "vim", "vimdoc", "query", "bash",
      "markdown", "markdown_inline",
    }

    -- `main` has no `ensure_installed`; install missing parsers explicitly.
    local installed = ts.get_installed("parsers")
    local missing = vim.tbl_filter(function(lang)
      return not vim.tbl_contains(installed, lang)
    end, ensure)
    if #missing > 0 then
      ts.install(missing)
    end

    -- `main` has no `highlight`/`indent` options either: Neovim core owns both,
    -- and we start them per-buffer.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if not lang or not vim.tbl_contains(ts.get_installed("parsers"), lang) then
          return
        end
        -- pcall: a failure here would abort the remaining FileType autocmds,
        -- including the one that sets 'syntax' -- leaving the buffer with no
        -- highlighting at all rather than falling back to legacy syntax.
        pcall(vim.treesitter.start, args.buf, lang)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
