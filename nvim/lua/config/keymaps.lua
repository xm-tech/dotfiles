-- =====================================================
-- ===================== MAPPINGS ======================

-- Space key does nothing
vim.keymap.set('n', '<space>', '<Nop>')

-- Use ; for commands
vim.keymap.set({'n', 'v'}, ';', ':')

-- Quickfix shortcuts
vim.keymap.set('n', '<C-n>', ':cn<CR>')
vim.keymap.set('n', '<C-m>', ':cp<CR>')
vim.keymap.set('n', '<leader>a', ':cclose<CR>')

-- Put quickfix window always to the bottom
vim.api.nvim_create_augroup('quickfix', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = 'quickfix',
  pattern = 'qf',
  callback = function()
    vim.cmd('wincmd J')
    vim.opt_local.wrap = true
  end
})

-- Enter automatically into the files directory
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  command = 'silent! lcd %:p:h'
})

-- Automatically resize screens to be equally the same
vim.api.nvim_create_autocmd('VimResized', {
  pattern = '*',
  command = 'wincmd ='
})

-- Fast saving and quitting
vim.keymap.set('n', '<leader>w', ':w!<cr>')
vim.keymap.set('n', '<leader>q', ':q!<CR>', { silent = true })

-- Remove search highlight
local function clear_highlight()
  vim.fn.setreg('/', '')
  if vim.bo.filetype == 'go' then
    vim.fn['go#guru#ClearSameIds']()
  end
end
vim.keymap.set('n', '<leader><space>', clear_highlight, { silent = true })

-- Echo the number under the cursor as binary
local function echo_binary()
  local cword = vim.fn.expand('<cword>')
  vim.api.nvim_echo({{string.format("%08b", tonumber(cword) or 0)}}, false, {})
end
vim.keymap.set('n', 'gb', echo_binary, { silent = true })

-- Close all but the current one
vim.keymap.set('n', '<leader>o', ':only<CR>')

-- Split
vim.keymap.set('n', '<Leader>h', ':split<CR>')
vim.keymap.set('n', '<Leader>v', ':vsplit<CR>')

-- Better split window switching
vim.keymap.set({'n', 'v'}, '<C-j>', '<C-W>j')
vim.keymap.set({'n', 'v'}, '<C-k>', '<C-W>k')
vim.keymap.set({'n', 'v'}, '<C-h>', '<C-W>h')
vim.keymap.set({'n', 'v'}, '<C-l>', '<C-W>l')

-- Better split window resize
vim.keymap.set('n', '<C-t>l', ':vertical resize +5<CR>', { silent = true })
vim.keymap.set('n', '<C-t>h', ':vertical resize -5<CR>', { silent = true })
vim.keymap.set('n', '<C-t>k', ':resize +5<CR>', { silent = true })
vim.keymap.set('n', '<C-t>j', ':resize -5<CR>', { silent = true })
vim.keymap.set('n', '<C-t>L', ':vertical resize +15<CR>', { silent = true })
vim.keymap.set('n', '<C-t>H', ':vertical resize -15<CR>', { silent = true })
vim.keymap.set('n', '<C-t>K', ':resize +15<CR>', { silent = true })
vim.keymap.set('n', '<C-t>J', ':resize -15<CR>', { silent = true })

-- Print full path
vim.keymap.set('n', '<s-f>', ':echo expand("%:p")<cr>')

-- Select all
vim.keymap.set('n', '<C-a>', 'ggVG$')

-- Maintain Visual Mode after shifting
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Move visual block
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Jump to the next '<++>' and edit it
vim.keymap.set('n', '<leader><leader>', '<Esc>/<++><CR>:nohlsearch<CR>cf>')

-- Terminal settings
vim.keymap.set('t', '<Leader>q', '<C-\\><C-n>:q!<cr>')
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l')

-- Open terminal in vertical, horizontal and new tab
vim.keymap.set('n', '<leader>tv', ':vsplit<cr>:terminal<CR>')
vim.keymap.set('n', '<leader>ts', ':split<cr>:terminal<CR>')
vim.keymap.set('n', '<leader>tt', ':tabnew<cr>:terminal<CR>')
vim.keymap.set('t', '<leader>tv', '<C-\\><C-n>:vsplit<cr>:terminal<CR>')
vim.keymap.set('t', '<leader>ts', '<C-\\><C-n>:split<cr>:terminal<CR>')
vim.keymap.set('t', '<leader>tt', '<C-\\><C-n>:tabnew<cr>:terminal<CR>')

-- Exit insert mode with jj
vim.keymap.set('i', 'jj', '<Esc>')

-- Toggle spell checking
vim.keymap.set('n', '<F6>', ':setlocal spell! spell?<CR>')

-- Center search results
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Center screen when moving up/down
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Remap H and L to beginning and end of line
vim.keymap.set('n', 'H', '^')
vim.keymap.set('n', 'L', '$')
vim.keymap.set('v', 'H', '^')
vim.keymap.set('v', 'L', 'g_')

-- Act like D and C
vim.keymap.set('n', 'Y', 'y$')

-- Don't show q: window
vim.keymap.set('n', 'q:', ':q')

-- Don't move on *
vim.keymap.set('n', '*', function()
  local view = vim.fn.winsaveview()
  vim.cmd('normal! *')
  vim.fn.winrestview(view)
end, { silent = true })

-- Search within visual selection
vim.keymap.set('v', '/', '<Esc>/\\%><C-R>=line("\'<")-1<CR>l\\%<<C-R>=line("\'>")+1<CR>l')
vim.keymap.set('v', '?', '<Esc>?\\%><C-R>=line("\'<")-1<CR>l\\%<<C-R>=line("\'>")+1<CR>l')

-- Visual Mode */# from Scrooloose
local function v_set_search()
  local temp = vim.fn.getreg('@')
  vim.cmd('normal! gvy')
  local escaped_search = vim.fn.escape(vim.fn.getreg('@'), '\\')
  escaped_search = vim.fn.substitute(escaped_search, '\\n', '\\\\n', 'g')
  vim.fn.setreg('/', '\\V' .. escaped_search)
  vim.fn.setreg('@', temp)
end

vim.keymap.set('v', '*', function()
  v_set_search()
  vim.cmd('normal! //<CR><c-o>')
end)

vim.keymap.set('v', '#', function()
  v_set_search()
  vim.cmd('normal! ??<CR><c-o>')
end)

-- Create a go doc comment based on the word under the cursor
local function create_go_doc_comment()
  if vim.bo.filetype ~= 'go' then
    return
  end
  vim.cmd('normal "zyiw')
  vim.cmd(':put! z')
  vim.cmd(':norm I// \\<Esc>$')
end
vim.keymap.set('n', '<leader>ui', create_go_doc_comment)

-- Insert mode movement
local function exec_and_return(cmd)
  vim.cmd('norm! ' .. cmd)
  return ''
end

vim.keymap.set('i', '<c-f>', function() return exec_and_return('e') end, { expr = true, silent = true })
vim.keymap.set('i', '<c-b>', function() return exec_and_return('b') end, { expr = true, silent = true })
vim.keymap.set('i', '<c-l>', function() return exec_and_return('l') end, { expr = true, silent = true })

-- Press ` to change case
vim.keymap.set('n', '`', '~')

-- Use ? to show documentation in preview window
local function show_documentation()
  local filetype = vim.bo.filetype
  if vim.tbl_contains({'vim', 'help'}, filetype) then
    vim.cmd('h ' .. vim.fn.expand('<cword>'))
  else
    vim.fn.CocAction('doHover')
  end
end
vim.keymap.set('n', '?', show_documentation)

-- Save a file as root
vim.keymap.set('n', '<leader>W', ':w !sudo tee % > /dev/null<CR>')
