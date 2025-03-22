-- =====================================================
-- ===================== BASIC SETTINGS ======================

-- Use Vim settings, rather than Vi settings
vim.opt.compatible = false

-- Disable Ruby provider
vim.g.loaded_ruby_provider = 0

-- Disable Perl provider
vim.g.loaded_perl_provider = 0

-- Set Python path for Neovim
if vim.fn.executable('python3') == 1 then
  vim.g.python3_host_prog = vim.fn.exepath('python3')
elseif vim.fn.executable('python') == 1 then
  vim.g.python3_host_prog = vim.fn.exepath('python')
end

-- Enable filetype detection and plugin/indent loading
vim.cmd('filetype plugin indent on')

-- Performance settings
vim.opt.ttyfast = true

-- Status line
vim.opt.laststatus = 2
vim.opt.encoding = 'utf-8'              -- Set default encoding to UTF-8
vim.opt.autoread = true                 -- Automatically reread changed files without asking
vim.opt.autoindent = true               -- Auto indent
vim.opt.backspace = 'indent,eol,start'  -- Makes backspace key more powerful
vim.opt.incsearch = true                -- Shows the match while typing
vim.opt.hlsearch = true                 -- Highlight found searches
vim.opt.mouse = 'a'                     -- Enable mouse mode

vim.opt.errorbells = false              -- No beeps
vim.opt.number = true                   -- Show line numbers
vim.opt.showcmd = true                  -- Show me what I'm typing
vim.opt.swapfile = false                -- Don't use swapfile
vim.opt.backup = false                  -- Don't create annoying backup files
vim.opt.writebackup = false             -- Don't create backup files while editing
vim.opt.splitright = true               -- Split vertical windows right to the current windows
vim.opt.splitbelow = true               -- Split horizontal windows below to the current windows
vim.opt.autowrite = true                -- Automatically save before :next, :make etc.
vim.opt.hidden = true                   -- Buffer should still exist if window is closed
vim.opt.fileformats = 'unix,dos,mac'    -- Prefer Unix over Windows over OS 9 formats
vim.opt.showmatch = false               -- Do not show matching brackets by flickering
vim.opt.showmode = false                -- We show the mode with statusline
vim.opt.ignorecase = true               -- Search case insensitive...
vim.opt.smartcase = true                -- ... but not it begins with upper case 
vim.opt.completeopt = 'menu,menuone'
vim.opt.cursorcolumn = false            -- Speed up syntax highlighting
vim.opt.cursorline = false
vim.opt.updatetime = 300                -- Faster completion and better UI updates
vim.opt.pumheight = 10                  -- Completion window max size
vim.opt.conceallevel = 2                -- Concealed text is completely hidden

vim.opt.shortmess:append('c')           -- Shut off completion messages
vim.opt.belloff:append('ctrlg')         -- If Vim beeps during completion

vim.opt.scrolloff = 5
vim.opt.lazyredraw = true               -- Don't redraw while executing macros

-- Clipboard settings
vim.opt.clipboard:append('unnamed')
vim.opt.clipboard:append('unnamedplus')

-- Increase max memory to show syntax highlighting for large files 
vim.opt.maxmempattern = 20000

-- ~/.viminfo needs to be writable and readable
vim.opt.viminfo = "'1000"

-- Persistent undo - controlled by performance.lua
-- vim.opt.undofile = true
-- vim.opt.undodir = vim.fn.expand('~/.cache/nvim/undo')

-- Create undo directory if it doesn't exist
vim.fn.mkdir(vim.fn.expand('~/.cache/nvim/undo'), 'p')

-- Color scheme
vim.cmd('syntax enable')
vim.opt.termguicolors = true
vim.opt.background = 'dark'
vim.g.molokai_original = 1
vim.g.rehash256 = 1

-- Load colorscheme after plugins are loaded
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.filereadable(vim.fn.expand('~/.config/nvim/colors/molokai.vim')) == 1 then
      vim.cmd('colorscheme molokai')
    else
      vim.cmd('colorscheme desert')
    end
  end
})
