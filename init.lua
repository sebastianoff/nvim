vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local map = vim.keymap.set
local input = vim.ui.input
local opts = { noremap = true, silent = true }

map({ 'n', 'v' }, '<leader><leader>', ':', { noremap = true })

map('i', 'jk', '<Esc>', opts)
map('v', 'jk', '<Esc>', opts)
map('t', 'jk', [[<C-\><C-n>]], opts)

map('n', 'H', '^', opts)
map('n', 'L', '$', opts)
map('n', 'Y', 'y$', opts)
map('n', 'U', '<C-r>', opts)
map('n', 'Q', '<nop>', opts)
map('n', '<leader>w', ':w<CR>', opts)

map('n', '<leader>x', ':x<CR>', opts)
map('n', '<leader>q', ':q<CR>', opts)
map('n', '<leader>Q', ':q!<CR>', opts)
map('n', '<leader>h', ':nohlsearch<CR>', opts)

map('n', '<Tab>', ':bnext<CR>', opts)
map('n', '<S-Tab>', ':bprevious<CR>', opts)
map('n', '<leader><Tab>', '<C-^>', opts)

map({ 'n', 'v' }, '<leader>y', '"+y', opts)
map('n', '<leader>Y', '"+Y', opts)
map({ 'n', 'v' }, '<leader>p', '"+p', opts)
map({ 'n', 'v' }, '<leader>P', '"+P', opts)

map('n', '<leader>a', 'ggVG', opts)
-- window management
map('n', '<leader>sv', ':vsplit<CR>', opts)
map('n', '<leader>sh', ':split<CR>', opts)
map('n', '<leader>sc', ':close<CR>', opts)
map('n', '<C-h>', '<C-w>h', opts)
map('n', '<C-j>', '<C-w>j', opts)
map('n', '<C-k>', '<C-w>k', opts)
map('n', '<C-l>', '<C-w>l', opts)
-- resizing
map('n', '<A-Left>',  '<cmd>vertical resize -4<CR>', { desc = 'Make narrower', silent = true })
map('n', '<A-Right>', '<cmd>vertical resize +4<CR>', { desc = 'Make wider', silent = true })
map('n', '<A-Up>',    '<cmd>resize +2<CR>', { desc = 'Make taller', silent = true })
map('n', '<A-Down>',  '<cmd>resize -2<CR>', { desc = 'Make shorter', silent = true })

map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)

map('n', '<A-j>', ':m .+1<CR>==', opts)
map('n', '<A-k>', ':m .-2<CR>==', opts)
map('i', '<A-j>', '<Esc>:m .+1<CR>==gi', opts)
map('i', '<A-k>', '<Esc>:m .-2<CR>==gi', opts)
map('v', '<A-j>', ":m '>+1<CR>gv=gv", opts)
map('v', '<A-k>', ":m '<-2<CR>gv=gv", opts)

-- async-run
map('n', '<leader>r', function()
        input({}, function(cmd)
                if cmd and #cmd > 0 then
                        vim.cmd('AsyncRun ' .. cmd)
                end
        end)
end, { desc = 'Run shell command' })
-- repeat last AsyncRun
map('n', '<leader>R', '<cmd>AsyncRun -repeat<CR>', { desc = 'Repeat last async run' })
-- quick fix
map('n', '<leader>co', '<cmd>copen<CR>', { desc = 'Quickfix open' })
map('n', '<leader>cc', '<cmd>cclose<CR>', { desc = 'Quickfix close' })
-- multi-cursor thingy, so I can quickly add X cursor above or below
local function vm_add(dir)
      local plug = (dir == 'down') and '<Plug>(VM-Add-Cursor-Down)' or '<Plug>(VM-Add-Cursor-Up)'
      local keys = vim.api.nvim_replace_termcodes(plug, true, true, true)
      local n = vim.v.count1
      for _ = 1, n do
        vim.api.nvim_feedkeys(keys, 'n', false)
      end
end

map('n', '<leader>j', function() vm_add('down') end, { desc = 'VM: add cursors below by count' })
map('n', '<leader>k', function() vm_add('up')   end, { desc = 'VM: add cursors above by count' })

local opt = vim.opt

opt.number = true 
opt.relativenumber = true
opt.signcolumn = 'yes'
opt.termguicolors = true 
opt.fillchars:append { eob = ' ' } 
opt.clipboard = "unnamedplus"

opt.list = true
opt.listchars = {
        tab = '»·',
        lead = '·',
        trail = '·',
        multispace = '·',
        nbsp = '␣',
        extends = '›',
        precedes = '‹',
}

opt.scrolloff = 6
opt.sidescrolloff = 6
opt.updatetime = 200
opt.confirm = true

opt.undofile = true

opt.breakindent = true
opt.linebreak = true
opt.showbreak = '↳ '

opt.grepprg = "rg --vimgrep --smart-case --hidden --glob=!.git/"
opt.grepformat = "%f:%l:%c:%m"

opt.laststatus = 3
opt.showmode = false 

opt.cmdheight = 0

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
        {
                  'catppuccin/nvim',
                  name = 'catppuccin',
                  lazy = false,
                  priority = 1000,
                  config = function()
                            require('catppuccin').setup({
                                      flavour = 'mocha',
                                      transparent_background = false,
                                      integrations = {
                                                leap = true,
                                                lualine = true,
                                      },
                            })
                            vim.cmd.colorscheme('catppuccin')
                  end,
        },
        {
                'skywind3000/asyncrun.vim',
                init = function() 
                        vim.g.asyncrun_open = 10
                        vim.g.asyncrun_bell = 0
                end,
        },
        { 'kylechui/nvim-surround', version = '*', config = function() require('nvim-surround').setup() end },
        { 'numToStr/Comment.nvim', opts = {} },
        { 'tpope/vim-repeat' },
        { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },
        { 'tpope/vim-sleuth' },
        { 'ggandor/leap.nvim', config = function() require('leap').add_default_mappings() end },
        { 'echasnovski/mini.ai', version = '*', opts = {} },
        { 'mg979/vim-visual-multi', branch = 'master' },
        { 'lewis6991/gitsigns.nvim', opts = {} },
        {
                'nvim-lualine/lualine.nvim',
                dependencies = { 'nvim-tree/nvim-web-devicons' },
                opts = {
                        options = {
                                theme = 'catppuccin',
                                globalstatus = true,
                                icons_enabled = true,
                                section_separators = { left = '', right = '' },
                                component_separators = { left = '│', right = '│' },
                                disabled_filetypes = { statusline = { 'alpha', 'starter' } },
                        },
                        sections = {
                                lualine_a = { { 'mode' } },
                                lualine_b = { 'branch', 'diff' },
                                lualine_c = {
                                        { 'filename', path = 1, symbols = { modified = ' [+]', readonly = ' ', unnamed = '[No Name]' } },
                                },
                                lualine_x = {
                                  {
                                          'diagnostics',
                                          sources = { 'nvim_diagnostic' },
                                          symbols = { error = ' ', warn = ' ', info = ' ', hint = '󰌵 ' },
                                  },
                                  'filetype',
                                },
                                lualine_y = { 'progress' },
                                lualine_z = { 'location' },
                        },
                        inactive_sections = {
                                lualine_a = {},
                                lualine_b = {},
                                lualine_c = { { 'filename', path = 1 } },
                                lualine_x = { 'location' },
                                lualine_y = {},
                                lualine_z = {},
                        },
                        extensions = { 'quickfix', 'lazy' },
                },
        }
})
