vim.g.netrw_banner = 0

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

vim.opt.updatetime = 50

vim.opt.signcolumn = "yes"

vim.opt.splitright = true

vim.opt.colorcolumn = "80"

local has_wsl = vim.fn.has("wsl") == 1
local has_tmux = vim.fn.has_key(vim.fn.environ(), "TMUX") == 1
local has_osc52, osc52 = pcall(require, "vim.ui.clipboard.osc52")

if not has_tmux then
  if has_wsl then
    vim.g.clipboard = {
      name = "wsl-clipboard",
      copy = {
        ["+"] = "clip.exe",
        ["*"] = "clip.exe",
      },
      paste = {
        ["+"] = [[powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))]],
        ["*"] = [[powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))]],
      },
    }
  end
  if has_osc52 then
    vim.g.clipboard = {
      name = "osc52-clipboard",
      copy = {
        ["+"] = osc52.copy("+"),
        ["*"] = osc52.copy("*"),
      },
      paste = {
        ["+"] = osc52.paste("+"),
        ["*"] = osc52.paste("*"),
      },
    }
  end
end
