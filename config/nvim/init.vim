
call plug#begin('~/.local/share/nvim/plugged')
    " Utils
    Plug 'NFrid/due.nvim'
    Plug 'norcalli/nvim-colorizer.lua'
    Plug 'christoomey/vim-system-copy'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'stevearc/dressing.nvim'
    Plug 'ziontee113/icon-picker.nvim'
    Plug 'lewis6991/gitsigns.nvim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'christoomey/vim-tmux-navigator'
    " Visualize
    Plug 'cocopon/iceberg.vim'
    Plug 'feline-nvim/feline.nvim'
    Plug 'lukas-reineke/indent-blankline.nvim'
    Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'kristijanhusak/defx-icons'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'kristijanhusak/defx-git'
    Plug 'simrat39/symbols-outline.nvim'
    " LanguageServer
    Plug 'williamboman/mason.nvim'
    Plug 'williamboman/mason-lspconfig.nvim'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'neovim/nvim-lspconfig'
    Plug 'https://git.sr.ht/~whynothugo/lsp_lines.nvim'
    " LanguageSpecific
    Plug 'jvirtanen/vim-hcl'
    Plug 'neoclide/jsonc.vim'
    Plug 'bfrg/vim-cpp-modern'
call plug#end()

let g:system_copy#copy_command='<COPYBIN>'
let g:system_copy#paste_command='<PASTEBIN>'

set number             " 行番号を表示　
set autoindent         " 改行時に自動でインデントする
set tabstop=4          " タブを何文字の空白に変換するか
set shiftwidth=4       " 自動インデント時に入力する空白の数
set expandtab          " タブ入力を空白に変換
set scrolloff=5        " スクロールする時に下が見えるようにする
set noswapfile         " .swapファイルを作らない
set nowritebackup      " バックアップファイルを作らない
set nobackup           " バックアップをしない
set switchbuf=useopen  " 新しく開く代わりにすでに開いてあるバッファを開く
set shiftround         " インデントをshiftwidthの倍数に丸める
set infercase          " 補完の際の大文字小文字の区別しない
set hidden             " 変更中のファイルでも、保存しないで他のファイルを表示
set switchbuf=useopen  " 新しく開く代わりにすでに開いてあるバッファを開く
set ignorecase         " 小文字の検索でも大文字も見つかるようにする
set smartcase          " ただし大文字も含めた検索の場合はその通りに検索する
set mouse=a            " マウス有効化
set noshowmode         " モード表示を消す

set clipboard^=unnamed,unnamedplus
set cursorline          " カーソルのある行をハイライトする
set list                " 不可視文字を表示
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:% " 不可視文字を表示

set termguicolors
set background=dark
colorscheme iceberg

" W でスーパーユーザーとして保存（sudoが使える環境限定）
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!

" ESCを二回押すことでハイライトを消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>

" j, k による移動を折り返されたテキストでも自然に振る舞うように変更
nnoremap j gj
nnoremap k gk
" vを二回で行末まで選択
vnoremap v $h

" Alt + hjkl でウィンドウ間を移動
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <M-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <M-j> :TmuxNavigateDown<cr>
nnoremap <silent> <M-k> :TmuxNavigateUp<cr><M-l>
nnoremap <silent> <M-l> :TmuxNavigateRight<cr>

" Shift + 矢印でウィンドウサイズを変更
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>

" split
nnoremap <leader>j :split<cr>
nnoremap <leader>l :vsplit<cr>

" tabキーで行番号を相対表示と切り替え
function! ToggleRelativeNumber()
    if &relativenumber
        set norelativenumber
    else
        set relativenumber
    endif
endfunction
nmap <silent> <tab> :call ToggleRelativeNumber()<CR>

" プラグイン用キーバインド
nnoremap <C-k> <cmd>Telescope find_files<cr>
nnoremap <C-b> <cmd>Defx<cr>
nnoremap <C-a> <cmd>SymbolsOutline<cr>

au FileType * set fo-=c fo-=r fo-=o
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" indentLine settings
let g:lightline = {
\   'colorscheme': 'iceberg',
\       'active': {
\           'left': [ [ 'mode', 'paste' ], [ 'readonly', 'absolutepath', 'modified' ] ],
\       }
\   }

lua << EOF
require('gitsigns').setup({
    on_attach = function(buffer)
        vim.opt.signcolumn = "yes"
    end
})
require('feline_config')

require('due_nvim').setup {}

require("indent_blankline").setup {
    char = '▏',
    show_current_context = true,
}

require('telescope').setup({
    defaults = {
        file_ignore_patterns = {"node_modules"},
        mappings = {
            i = {
                ["<esc>"] = "close",
            },
        },
    },
})

require("icon-picker").setup({ disable_legacy_commands = true })

local signs = { Error = "", Warn = "", Hint = "ﳁ", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

require("mason").setup()
require('mason-lspconfig').setup_handlers({ function(server)
    local opt = {
        capabilities = require('cmp_nvim_lsp').update_capabilities(
            vim.lsp.protocol.make_client_capabilities()
        ),
        on_attach = function(client, bfnr)
            vim.opt.signcolumn = "yes"
        end
    }
    require('lspconfig')[server].setup(opt)
end })

local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    sources = {
        { name = "nvim_lsp" },
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ['<C-l>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm { select = true },
    }),
    experimental = {
        ghost_text = true,
    },
})

require("symbols-outline").setup({
    symbols = {
        File          = {icon = "", hl = "TSURI"},
        Package       = {icon = "", hl = "TSNamespace"},
        Module        = {icon = "", hl = "TSNamespace"},
        Namespace     = {icon = "", hl = "TSNamespace"},
        Interface     = {icon = "", hl = "TSType"},
        TypeParameter = {icon = "", hl = "TSParameter"},
        Class         = {icon = "", hl = "TSType"},
        Constructor   = {icon = "ƒ", hl = "TSConstructor"},
        Method        = {icon = "ƒ", hl = "TSMethod"},
        Function      = {icon = "ƒ", hl = "TSFunction"},
        Property      = {icon = "", hl = "TSMethod"},
        Field         = {icon = "", hl = "TSField"},
        Variable      = {icon = "", hl = "TSConstant"},
        Constant      = {icon = "", hl = "TSConstant"},
        String        = {icon = "", hl = "TSString"},
        Number        = {icon = "藍", hl = "TSNumber"},
        Boolean       = {icon = "ﲉ", hl = "TSBoolean"},
        Enum          = {icon = "", hl = "TSType"},
        Struct        = {icon = "", hl = "TSType"},
        Array         = {icon = "", hl = "TSConstant"},
        Object        = {icon = "", hl = "TSType"},
        Key           = {icon = "", hl = "TSType"},
        Null          = {icon = "ﳠ", hl = "TSType"},
        EnumMember    = {icon = "", hl = "TSField"},
        Event         = {icon = "", hl = "TSType"},
        Operator      = {icon = "ﬦ", hl = "TSOperator"},
    }
})

require("lsp_lines").setup()
vim.diagnostic.config({
    virtual_text = false,
})
vim.keymap.set(
    "",
    "<Leader>l",
    require("lsp_lines").toggle,
    { desc = "Toggle lsp_lines" }
)

EOF

let g:defx_icons_column_length = 2
autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
   \ defx#do_action('drop')
  nnoremap <silent><buffer><expr> c
  \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> m
  \ defx#do_action('move')
  nnoremap <silent><buffer><expr> p
  \ defx#do_action('paste')
  nnoremap <silent><buffer><expr> l
  \ defx#do_action('drop')
  nnoremap <silent><buffer><expr> h
  \ defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> t
  \ defx#do_action('open','tabnew')
  nnoremap <silent><buffer><expr> i
  \ defx#do_action('drop', 'vsplit')
  nnoremap <silent><buffer><expr> o
  \ defx#do_action('open_or_close_tree')
  nnoremap <silent><buffer><expr> ~
  \ defx#do_action('cd')
  nnoremap <silent><buffer><expr> q
  \ defx#do_action('quit')
endfunction

call defx#custom#option('_', {
\   'winwidth': 40,
\   'split': 'vertical',
\   'direction': 'topleft',
\   'show_ignored_files': 1,
\   'buffer_name': 'exlorer',
\   'toggle': 1,
\   'resume': 1,
\   'columns': 'indent:icons:filename:type:git:mark',
\   })

call defx#custom#column('git', 'indicators', {
\   'Modified'  : '',
\   'Staged'    : '',
\   'Renamed'   : '',
\   'Ignored'   : '',
\   'Deleted'   : '',
\   'Untracked' : '',
\   'Unknown'   : ''
\   })
call defx#custom#column('filename', 'min_width', 28)
call defx#custom#column('filename', 'max_width', 28)
call defx#custom#column('git', 'column_length', 2)

autocmd BufWritePost * call defx#redraw()
autocmd BufEnter * call defx#redraw()

" for symbols-outline.nvim
hi FocusedSymbol ctermbg=237 ctermfg=255 guibg=#3e445e guifg=#ffffff

