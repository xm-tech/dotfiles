-- =====================================================
-- ===================== PLUGINS ======================

-- Install packer if not installed
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd('packadd packer.nvim')
end

-- Auto compile when there are changes in plugins.lua
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

-- Initialize packer
return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Editing and navigation
  use 'AndrewRadev/splitjoin.vim'
  use 'ConradIrwin/vim-bracketed-paste'
  use 'Raimondi/delimitMate'
  use 'tpope/vim-commentary'
  use 'tpope/vim-eunuch'
  use 'tpope/vim-repeat'

  -- Completion and snippets
  use {
    'L3MON4D3/LuaSnip',
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
      require('luasnip').setup({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = true,
      })
      
      -- Load friendly-snippets
      require('luasnip.loaders.from_vscode').lazy_load()
      
      -- Keymappings
      vim.keymap.set({"i", "s"}, "<Tab>", function()
        if require('luasnip').expand_or_jumpable() then
          return "<Plug>luasnip-expand-or-jump"
        else
          return "<Tab>"
        end
      end, {silent = true, expr = true})
      
      vim.keymap.set({"i", "s"}, "<S-Tab>", function()
        if require('luasnip').jumpable(-1) then
          return "<Plug>luasnip-jump-prev"
        else
          return "<S-Tab>"
        end
      end, {silent = true, expr = true})
    end
  }
  use 'ervandew/supertab'
  use {
    'neoclide/coc.nvim',
    branch = 'release',
    config = function()
      -- Global extensions
      vim.g.coc_global_extensions = {
        'coc-json',
        'coc-vimlsp',
        'coc-pyright',
        'coc-sh',
        'coc-go',
        'coc-lua',
        'coc-tsserver',
        'coc-clangd',
        'coc-rust-analyzer'
        -- Removed coc-snippets as we're using LuaSnip now
      }

      -- Use <c-space> to trigger completion
      vim.keymap.set('i', '<c-space>', 'coc#refresh()', { silent = true, expr = true })

      -- Handle CR in popup menu
      vim.keymap.set('i', '<CR>', 'coc#pum#visible() ? coc#pum#confirm() : "\\<C-y>"', { expr = true, silent = true })
    end
  }

  -- Language support
  use {
    'fatih/vim-go',
    ft = 'go',
    run = ':GoUpdateBinaries',
    config = function()
      -- Disable certain vim-go features that might be slow
      vim.g.go_highlight_types = 0
      vim.g.go_highlight_fields = 0
      vim.g.go_highlight_functions = 0
      vim.g.go_highlight_function_calls = 0
      vim.g.go_highlight_operators = 0
      vim.g.go_highlight_extra_types = 0
      vim.g.go_highlight_build_constraints = 0
      vim.g.go_highlight_generate_tags = 0
    end
  }
  use { 'fatih/vim-hclfmt', ft = 'hcl' }
  use { 'fatih/vim-nginx', ft = 'nginx' }
  use { 'cespare/vim-toml', ft = 'toml' }
  use { 'elzr/vim-json', ft = 'json',
    config = function()
      vim.g.vim_json_syntax_conceal = 0
    end
  }
  use {
    'plasticboy/vim-markdown',
    ft = 'markdown',
    config = function()
      vim.g.vim_markdown_folding_disabled = 1
    end
  }
  use { 'vim-scripts/indentpython.vim', ft = 'python' }
  use { 'tmux-plugins/vim-tmux', ft = 'tmux' }
  use { 'ekalinin/Dockerfile.vim', ft = 'Dockerfile' }
  use { 'hashivim/vim-hashicorp-tools', ft = {'terraform', 'hcl', 'vagrant'} }
  use { 'rhysd/vim-clang-format', ft = {'c', 'cpp', 'objc'} }
  use { 'skywind3000/vim-cppman', ft = {'c', 'cpp'} }

  -- Text manipulation
  use { 'arthurxavierx/vim-caser', cmd = {'Camelcase', 'Snakecase', 'Kebabcase', 'Pascalcase'} }
  use { 'godlygeek/tabular', cmd = 'Tabularize' }

  -- Git integration
  use {
    'tpope/vim-fugitive',
    cmd = {'Git', 'Gblame', 'Gvdiffsplit'},
    config = function()
      -- Fugitive mappings
      vim.keymap.set('v', '<leader>gb', ':Gblame<CR>')
      vim.keymap.set('n', '<leader>gb', ':Gblame<CR>')
      vim.keymap.set('n', '<leader>gd', ':Gvdiffsplit!<CR>')
      vim.keymap.set('n', 'gdh', ':diffget //2<CR>')
      vim.keymap.set('n', 'gdl', ':diffget //3<CR>')
    end
  }

  -- File navigation and search
  use {
    'Yggdroot/LeaderF',
    run = ':LeaderfInstallCExtension',
    config = function()
      -- Optimize LeaderF
      vim.g.Lf_MruMaxFiles = 100
      vim.g.Lf_UseVersionControlTool = 0
      vim.g.Lf_UseMemoryCache = 0
      vim.g.Lf_UseCache = 0
      
      -- Try to use Python 3 if available
      if vim.fn.has('python3') == 1 then
        vim.g.Lf_PythonVersion = 3
      else
        -- Fallback to Python 2 if Python 3 is not available
        vim.g.Lf_PythonVersion = 2
      end
      
      -- Set LeaderF key mappings
      vim.keymap.set('n', '<leader>f', ':Leaderf file<CR>')
      vim.keymap.set('n', '<leader>b', ':Leaderf buffer<CR>')
      vim.keymap.set('n', '<leader>m', ':Leaderf mru<CR>')
      vim.keymap.set('n', '<leader>t', ':Leaderf tag<CR>')
    end
  }
  use 'justinmk/vim-dirvish'
  use {
    'mileszs/ack.vim',
    cmd = 'Ack'
  }

  -- Markdown preview
  use {
    'iamcco/markdown-preview.nvim',
    run = function() vim.fn['mkdp#util#install_sync']() end,
    ft = {'markdown', 'vim-plug'}
  }

  -- Misc
  use { 'corylanou/vim-present', ft = 'present' }
  use 'fatih/molokai'
  use 'roxma/vim-tmux-clipboard'
  use 'tmux-plugins/vim-tmux-focus-events'
  use { 'tpope/vim-scriptease', ft = 'vim' }
  use {
    'tyru/open-browser.vim',
    keys = '<Plug>(openbrowser-smart-search)',
    config = function()
      -- Disable netrw's gx mapping
      vim.g.netrw_nogx = 1
      vim.keymap.set('n', 'gx', '<Plug>(openbrowser-smart-search)')
      vim.keymap.set('v', 'gx', '<Plug>(openbrowser-smart-search)')
    end
  }

  -- Tags
  use {
    'ludovicchabant/vim-gutentags',
    config = function()
      -- Optimize gutentags settings
      vim.g.gutentags_enabled = 1
      vim.g.gutentags_generate_on_new = 0
      vim.g.gutentags_generate_on_missing = 0
      vim.g.gutentags_generate_on_write = 0
      vim.g.gutentags_generate_on_empty_buffer = 0
      vim.g.gutentags_ctags_extra_args = {'--fields=+niazS', '--extra=+q'}
      vim.g.gutentags_ctags_exclude = {
        '*.git', '*.svg', '*.hg',
        'build',
        'dist',
        '*sites/*/files/*',
        'bin',
        'node_modules',
        'bower_components',
        'cache',
        'compiled',
        'docs',
        'example',
        'bundle',
        'vendor',
        '*.md',
        '*-lock.json',
        '*.lock',
        '*bundle*.js',
        '*build*.js',
        '.*rc*',
        '*.json',
        '*.min.*',
        '*.map',
        '*.bak',
        '*.zip',
        '*.pyc',
        '*.class',
        '*.sln',
        '*.Master',
        '*.csproj',
        '*.tmp',
        '*.csproj.user',
        '*.cache',
        '*.pdb',
        'tags*',
        'cscope.*',
        '*.css',
        '*.less',
        '*.scss',
        '*.exe', '*.dll',
        '*.mp3', '*.ogg', '*.flac',
        '*.swp', '*.swo',
        '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
        '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
        '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
      }
    end
  }
  use 'skywind3000/gutentags_plus'
  use { 'skywind3000/vim-preview', cmd = 'PreviewTag' }

  -- SuperTab configuration
  vim.g.SuperTabDefaultCompletionType = "context"
  vim.g.SuperTabContextTextOmniPrecedence = {'&omnifunc', '&completefunc'}

  -- DelimitMate configuration
  vim.g.delimitMate_expand_cr = 1
  vim.g.delimitMate_expand_space = 1
  vim.g.delimitMate_smart_quotes = 1
  vim.g.delimitMate_expand_inside_quotes = 0
  vim.g.delimitMate_smart_matchpairs = '^\\%(\\w\\|\\$\\)'
end)
