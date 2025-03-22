-- =====================================================
-- ===================== STATUSLINE ====================

-- Define mode names
local modes = {
  ['n'] = 'NORMAL',
  ['i'] = 'INSERT',
  ['R'] = 'REPLACE',
  ['v'] = 'VISUAL',
  ['V'] = 'V-LINE',
  [''] = 'V-BLOCK', -- Ctrl+v
  ['c'] = 'COMMAND',
  ['s'] = 'SELECT',
  ['S'] = 'S-LINE',
  [''] = 'S-BLOCK', -- Ctrl+s
  ['t'] = 'TERMINAL'
}

-- Keep track of previous mode
local prev_mode = ""

-- Function to get current mode with highlighting
local function status_line_mode()
  local cur_mode = modes[vim.api.nvim_get_mode().mode] or ''
  
  -- Do not update highlight if the mode is the same
  if cur_mode == prev_mode then
    return cur_mode
  end
  
  if cur_mode == "NORMAL" then
    vim.cmd('hi! StatusLine ctermfg=236')
    vim.cmd('hi! myModeColor cterm=bold ctermbg=148 ctermfg=22')
  elseif cur_mode == "INSERT" then
    vim.cmd('hi! myModeColor cterm=bold ctermbg=23 ctermfg=231')
  elseif cur_mode == "VISUAL" or cur_mode == "V-LINE" or cur_mode == "V-BLOCK" then
    vim.cmd('hi! StatusLine ctermfg=236')
    vim.cmd('hi! myModeColor cterm=bold ctermbg=208 ctermfg=88')
  end
  
  prev_mode = cur_mode
  return cur_mode
end

-- Function to get filetype
local function status_line_filetype()
  if vim.fn.winwidth(0) > 70 then
    local filetype = vim.bo.filetype
    return (filetype and filetype ~= '') and filetype or 'no ft'
  else
    return ''
  end
end

-- Function to get percentage through file
local function status_line_percent()
  return string.format("%d%%", math.floor(100 * vim.fn.line('.') / vim.fn.line('$')))
end

-- Function for left info
local function status_line_left_info()
  return ''
end

-- Set up highlight groups
vim.cmd('hi! myInfoColor ctermbg=240 ctermfg=252')

-- Build the statusline
vim.opt.statusline = ""
vim.opt.statusline:append("%#myModeColor#%{v:lua.require'config.statusline'.status_line_mode()}%*")
vim.opt.statusline:append("%#myInfoColor# %{v:lua.require'config.statusline'.status_line_left_info()} %*")
vim.opt.statusline:append("%#goStatuslineColor#%{&filetype=='go'?v:lua.require'config.statusline'.go_status():''}%*")
vim.opt.statusline:append("%=")
vim.opt.statusline:append("%#myInfoColor# %{v:lua.require'config.statusline'.status_line_filetype()} %{v:lua.require'config.statusline'.status_line_percent()} %l:%v %*")

-- Function to get Go status (requires vim-go)
local function go_status()
  if vim.bo.filetype == 'go' and vim.fn.exists('*go#statusline#Show') == 1 then
    return vim.fn['go#statusline#Show']()
  end
  return ''
end

-- Export functions for use in statusline
return {
  status_line_mode = status_line_mode,
  status_line_filetype = status_line_filetype,
  status_line_percent = status_line_percent,
  status_line_left_info = status_line_left_info,
  go_status = go_status
}
