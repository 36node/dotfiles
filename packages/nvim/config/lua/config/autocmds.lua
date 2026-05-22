-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- LazyVim 只在 FocusGained/TermClose/TermLeave 上 :checktime，nvim 持续在前台
-- 时（如 claude 改文件、:! 调用 git commit）不会触发。这里在光标停留和切
-- buffer 时也补一次，并对外部修改弹提示。
local checktime = vim.api.nvim_create_augroup("user_checktime", { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "BufEnter" }, {
  group = checktime,
  callback = function()
    if vim.o.buftype == "" then
      vim.cmd("silent! checktime")
    end
  end,
})
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = checktime,
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.WARN)
  end,
})
