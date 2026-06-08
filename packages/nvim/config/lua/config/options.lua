-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Spell: skip CJK chars; split camelCase; use a project-wide add-file for jargon.
-- Add a word under cursor with `zg`; remove with `zug`. See :help spell.
vim.opt.spelllang = { "en", "cjk" }
vim.opt.spelloptions:append("camel")
vim.opt.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"

vim.opt.relativenumber = false
