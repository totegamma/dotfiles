
call plug#begin('~/.local/share/nvim/plugged')
    " Utils
    Plug 'norcalli/nvim-colorizer.lua'
    Plug 'christoomey/vim-system-copy'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'stevearc/dressing.nvim'
    Plug 'ziontee113/icon-picker.nvim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    " Visualize
    Plug 'cocopon/iceberg.vim'
    Plug 'itchyny/lightline.vim'
    Plug 'lukas-reineke/indent-blankline.nvim'
    " LanguageServer
    Plug 'williamboman/mason.nvim'
    Plug 'williamboman/mason-lspconfig.nvim'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'neovim/nvim-lspconfig'
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
set scrolloff=5         " スクロールする時に下が見えるようにする
set noswapfile          " .swapファイルを作らない
set nowritebackup       " バックアップファイルを作らない
set nobackup            " バックアップをしない
set switchbuf=useopen   " 新しく開く代わりにすでに開いてあるバッファを開く
set shiftround          " インデントをshiftwidthの倍数に丸める
set infercase           " 補完の際の大文字小文字の区別しない
set hidden              " 変更中のファイルでも、保存しないで他のファイルを表示
set switchbuf=useopen   " 新しく開く代わりにすでに開いてあるバッファを開く
set ignorecase          " 小文字の検索でも大文字も見つかるようにする
set smartcase           " ただし大文字も含めた検索の場合はその通りに検索する

set clipboard+=unnamedplus
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

" Ctrl + hjkl でウィンドウ間を移動
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Shift + 矢印でウィンドウサイズを変更
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>

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
require("indent_blankline").setup {
    char = '▏',
    show_current_context = true,
}

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

EOF

