

" dein.vimが置かれる場所
let s:deinDir = expand("~/.vim/dein")
" dein.vim本体
let s:deinVim = s:deinDir . "/dein.vim"
" プラグインリスト
let s:pluginList = expand("~/.vim/pluginList.toml")

" dein.vimがインストールされてなければインストールする
if &runtimepath !~# "/dein.vim"
	if !isdirectory(s:deinVim)

		"dein.vimのインストール
		silent "!git clone https://github.com/Shougo/dein.vim" s:deinVim

		"molokai.vimのインストール
		silent "!mkdir ~/.vim/colors"
		silent "!git clone https://github.com/tomasr/molokai ~/.vim/tmp"
		silent "!mv ~/.vim/tmp/colors/molokai.vim ~/.vim/colors"
		silent "!rm -rf ~/.vim/tmp"

	endif
	execute "set runtimepath^=" . fnamemodify(s:deinVim, ":p")
endif

" dein.vimの設定をする
if dein#load_state(s:deinDir)
	call dein#begin(s:deinDir)

	" TOMLを読み込み、キャッシュしておく
	call dein#load_toml(s:pluginList, {"lazy": 0})

	"設定終了
	call dein#end()
	call dein#save_state()
endif

"未インストールのプラグインがあればインストールする
if dein#check_install()
	call dein#install()
endif


" ### vim基本設定
" 256色モードを使用する
set t_Co=256
" lightline用の設定
set laststatus=2
" ファイルタイプ別のプラグイン/インデントを有効にする
filetype plugin indent on
" カラースキマの設定
set background=dark
colorscheme molokai

" シンタックスハイライト
syntax on
" エンコード
set encoding=utf8
" ファイルエンコード
set fileencoding=utf-8
" スクロールする時に下が見えるようにする
set scrolloff=5
" .swapファイルを作らない
set noswapfile
" バックアップファイルを作らない
set nowritebackup
" バックアップをしない
set nobackup
" バックスペースで各種消せるようにする
set backspace=indent,eol,start
" ビープ音を消す
set vb t_vb=
set novisualbell
" OSのクリップボードを使う
set clipboard=unnamedplus
" 不可視文字を表示
set list
" 行番号を表示
set number
" 右下に表示される行・列の番号を表示する
set ruler
" compatibleオプションをオフにする
set nocompatible
" 移動コマンドを使ったとき、行頭に移動しない
set nostartofline
" 対応括弧に<と>のペアを追加
set matchpairs& matchpairs+=<:>
" 対応括弧をハイライト表示する
set showmatch
" 対応括弧の表示秒数を3秒にする
set matchtime=3
" ウィンドウの幅より長い行は折り返され、次の行に続けて表示される
set wrap
" 入力されているテキストの最大幅を無効にする
set textwidth=0
" 不可視文字を表示
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲
" インデントをshiftwidthの倍数に丸める
set shiftround
" 補完の際の大文字小文字の区別しない
set infercase
" 変更中のファイルでも、保存しないで他のファイルを表示
set hidden
" 新しく開く代わりにすでに開いてあるバッファを開く
set switchbuf=useopen
" 小文字の検索でも大文字も見つかるようにする
set ignorecase
" ただし大文字も含めた検索の場合はその通りに検索する
set smartcase
" インクリメンタルサーチを行う
set incsearch
" 検索結果をハイライト表示
set hlsearch
" コマンド、検索パターンを10000個まで履歴に残す
set history=10000
" マウスモード有効
set mouse=a
" xtermとscreen対応
set ttymouse=xterm2
" コマンドを画面最下部に表示する
set showcmd
" タブをタブとして扱う
set noexpandtab
" 改行時に前の行のインデントを継続する
set autoindent
" 改行時に入力された行の末尾に合わせて次のインデントを増減する
set smartindent
" tabの大きさをスペース4個分にする
set tabstop=4
" 自動インデントでずれる幅 
set shiftwidth=4
set softtabstop=4
" 自動でコメントにしない
augroup auto_comment_off
	autocmd!
	autocmd CursorMoved * setlocal formatoptions-=r
	autocmd CursorMoved * setlocal formatoptions-=o
augroup END
" カーソルのある行をハイライトする
set cursorline

if has('gui_macvim')
	set transparency=4
endif

" ### キーリマップの設定

" w!! でスーパーユーザーとして保存（sudoが使える環境限定）
cmap w!! w !sudo tee > /dev/null %
" ESCを二回押すことでハイライトを消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>
" カーソル下の単語を * で検索
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>
" visualモードで連続ペーストできるようにする
vnoremap <silent> p ""p
vnoremap <silent> P "0p
nnoremap <silent> p ""p
" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
" j, k による移動を折り返されたテキストでも自然に振る舞うように変更
nnoremap j gj
nnoremap k gk
" vを二回で行末まで選択
vnoremap v $h
" TABにて対応ペアにジャンプ
nnoremap &lt;Tab&gt; %
vnoremap &lt;Tab&gt; %
" Ctrl + e でNerdTreeのon/off切り替え
nnoremap <silent><C-e> :NERDTreeToggle<CR>

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

nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#seep_sessions() : "\<C-c>"

