vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local map = vim.keymap.set
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

map('n', '<leader>sv', ':vsplit<CR>', opts)
map('n', '<leader>sh', ':split<CR>', opts)
map('n', '<leader>sc', ':close<CR>', opts)
map('n', '<C-h>', '<C-w>h', opts)
map('n', '<C-j>', '<C-w>j', opts)
map('n', '<C-k>', '<C-w>k', opts)
map('n', '<C-l>', '<C-w>l', opts)

map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)

map('n', '<A-j>', ':m .+1<CR>==', opts)
map('n', '<A-k>', ':m .-2<CR>==', opts)
map('i', '<A-j>', '<Esc>:m .+1<CR>==gi', opts)
map('i', '<A-k>', '<Esc>:m .-2<CR>==gi', opts)
map('v', '<A-j>', ":m '>+1<CR>gv=gv", opts)
map('v', '<A-k>', ":m '<-2<CR>gv=gv", opts)

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

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
        { 'kylechui/nvim-surround', version = '*', config = function() require('nvim-surround').setup() end },
        { 'numToStr/Comment.nvim', opts = {} },
        { 'tpope/vim-repeat' },
        { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },
        { 'tpope/vim-sleuth' },
        { 'ggandor/leap.nvim', config = function() require('leap').add_default_mappings() end },
        { 'echasnovski/mini.ai', version = '*', opts = {} },
        { 'mg979/vim-visual-multi', branch = 'master' },
})
