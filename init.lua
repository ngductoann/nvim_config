require "options"

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "lazy_config"
_G.LazyVim = require "util"
_G.LazyVim.icons = require "icons"

-- load plugins
require("lazy").setup({
  { import = "plugins" },
  { import = "langs" },
}, lazy_config)

require "mappings"
require "statusline"
require "tabline"
require "commands"
require "colors"
