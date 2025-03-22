-- =================================================================
-- ===================== PERFORMANCE OPTIMIZATIONS =================
-- =================================================================

-- Disable backup, swap, and undo files for performance
-- Note: backup and swapfile are already disabled in options.lua
vim.opt.undofile = false  -- Disable persistent undo for better performance

-- Disable syntax highlighting for large files
vim.cmd([[
  augroup large_file
    autocmd!
    autocmd BufReadPre * let f=getfsize(expand("<afile>")) | if f > 1024*1024 || f == -2 | set eventignore+=FileType | setlocal syntax= | else | set eventignore-=FileType | endif
  augroup END
]])

-- Optimize for large files
vim.cmd([[
  augroup large_file_optimizations
    autocmd!
    autocmd BufReadPre * if getfsize(expand("<afile>")) > 1024*1024 |
          \ setlocal nofoldenable |
          \ setlocal nospell |
          \ setlocal norelativenumber |
          \ setlocal nocursorline |
          \ setlocal nocursorcolumn |
          \ endif
  augroup END
]])

-- Optimize LeaderF settings
vim.g.Lf_MruMaxFiles = 100
vim.g.Lf_UseVersionControlTool = 0
vim.g.Lf_UseMemoryCache = 0
vim.g.Lf_UseCache = 0

-- Force Python 3 for LeaderF
vim.g.Lf_PythonVersion = 3

-- Optimize gutentags settings
vim.g.gutentags_generate_on_new = 0
vim.g.gutentags_generate_on_missing = 0
vim.g.gutentags_generate_on_write = 0
vim.g.gutentags_generate_on_empty_buffer = 0

-- Optimize for tmux
if os.getenv("TMUX") then
  vim.opt.ttimeoutlen = 10
  vim.opt.cursorline = false
  vim.opt.cursorcolumn = false
  vim.opt.relativenumber = false
  vim.opt.updatetime = 500  -- Increase updatetime in tmux to reduce screen updates
end

-- Verification function to check if performance settings are applied
function _G.verify_performance_settings()
  local settings = {
    backup = vim.opt.backup:get(),
    writebackup = vim.opt.writebackup:get(),
    swapfile = vim.opt.swapfile:get(),
    undofile = vim.opt.undofile:get(),
    updatetime = vim.opt.updatetime:get(),
    lazyredraw = vim.opt.lazyredraw:get(),
  }
  
  print("Performance settings verification:")
  print("- backup: " .. tostring(settings.backup))
  print("- writebackup: " .. tostring(settings.writebackup))
  print("- swapfile: " .. tostring(settings.swapfile))
  print("- undofile: " .. tostring(settings.undofile))
  print("- updatetime: " .. tostring(settings.updatetime))
  print("- lazyredraw: " .. tostring(settings.lazyredraw))
  print("- LeaderF Python version: " .. tostring(vim.g.Lf_PythonVersion))
end

-- Create a command to verify settings
vim.cmd("command! VerifyPerformance lua _G.verify_performance_settings()")
