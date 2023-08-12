local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  "airblade/vim-gitgutter",
  "sheerun/vim-polyglot",
  "tomasiser/vim-code-dark",
  "tpope/vim-commentary",
  "tpope/vim-sensible",
  "tpope/vim-vinegar",
  "vim-airline/vim-airline",
  "vim-airline/vim-airline-themes",
})

vim.cmd.colorscheme('codedark')