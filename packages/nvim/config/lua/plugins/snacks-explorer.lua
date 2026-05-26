return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          hidden = true,
          ignored = true,
        },
      },
    },
  },
  init = function()
    local function set_hl()
      vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { link = "Normal" })
      vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUntracked", { link = "Added" })
      vim.api.nvim_set_hl(0, "SnacksPickerDirectory", { link = "Normal" })
    end
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_hl })
    set_hl()
  end,
}
