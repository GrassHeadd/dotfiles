return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = {
        "c", "lua", "vim", "vimdoc", "query",
        "javascript", "typescript", "python", "html", "css", "json",
        "go",
      },
      auto_install = true,
    })
  end,
}
