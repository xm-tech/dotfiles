-- =====================================================
-- ===================== FILETYPE SETTINGS ======================

-- Create a group for filetype detection
local filetypedetect = vim.api.nvim_create_augroup('filetypedetect', { clear = true })

-- Help command
vim.api.nvim_create_user_command('Help', function(opts)
  vim.cmd('vertical belowright help ' .. opts.args)
end, { nargs = '*', complete = 'help' })

-- Move help window to the right
vim.api.nvim_create_autocmd('FileType', {
  group = filetypedetect,
  pattern = 'help',
  command = 'wincmd L'
})

-- File type detection
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = filetypedetect,
  pattern = {'.tmux.conf*', 'tmux.conf*'},
  command = 'setf tmux'
})

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = filetypedetect,
  pattern = {'.nginx.conf*', 'nginx.conf*'},
  command = 'setf nginx'
})

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = filetypedetect,
  pattern = '*.hcl',
  command = 'setf conf'
})

vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
  group = filetypedetect,
  pattern = '*.gotmpl',
  command = 'set filetype=gotexttmpl'
})

vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
  group = filetypedetect,
  pattern = '*.puml',
  command = 'setfiletype plantuml'
})

-- Indentation settings
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = filetypedetect,
  pattern = '*.ino',
  command = 'setlocal noet ts=4 sw=4 sts=4'
})

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = filetypedetect,
  pattern = '*.txt',
  command = 'setlocal noet ts=2 sw=2'
})

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = filetypedetect,
  pattern = '*.md',
  command = 'setlocal expandtab ts=2 sw=2'
})

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = filetypedetect,
  pattern = '*.html',
  command = 'setlocal noet ts=4 sw=4'
})

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = filetypedetect,
  pattern = '*.vim',
  command = 'setlocal expandtab shiftwidth=2 tabstop=2'
})

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = filetypedetect,
  pattern = '*.hcl',
  command = 'setlocal expandtab shiftwidth=2 tabstop=2'
})

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = filetypedetect,
  pattern = '*.sh',
  command = 'setlocal expandtab shiftwidth=2 tabstop=2'
})

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = filetypedetect,
  pattern = '*.proto',
  command = 'setlocal expandtab shiftwidth=2 tabstop=2'
})

-- Language specific settings
vim.api.nvim_create_autocmd('FileType', {
  group = filetypedetect,
  pattern = 'go',
  command = 'setlocal noexpandtab tabstop=4 shiftwidth=4'
})

vim.api.nvim_create_autocmd('FileType', {
  group = filetypedetect,
  pattern = 'yaml',
  command = 'setlocal ts=2 sts=2 sw=2 expandtab'
})

vim.api.nvim_create_autocmd('FileType', {
  group = filetypedetect,
  pattern = 'json',
  command = 'setlocal expandtab shiftwidth=2 tabstop=2'
})

vim.api.nvim_create_autocmd('FileType', {
  group = filetypedetect,
  pattern = 'ruby',
  command = 'setlocal expandtab shiftwidth=2 tabstop=2'
})

vim.api.nvim_create_autocmd('FileType', {
  group = filetypedetect,
  pattern = 'make',
  command = 'set noexpandtab shiftwidth=8 softtabstop=0'
})

-- Language specific mappings
vim.api.nvim_create_autocmd('FileType', {
  group = filetypedetect,
  pattern = {'c', 'cpp', 'objc'},
  callback = function()
    vim.keymap.set('n', '<Leader>cf', ':<C-u>ClangFormat<CR>', { buffer = true })
    vim.keymap.set('v', '<Leader>cf', ':ClangFormat<CR>', { buffer = true })
  end
})

vim.api.nvim_create_autocmd('FileType', {
  group = filetypedetect,
  pattern = 'plantuml',
  callback = function()
    vim.keymap.set('n', '<leader>r', ':!plantuml -tsvg %<CR>', { buffer = true })
  end
})
