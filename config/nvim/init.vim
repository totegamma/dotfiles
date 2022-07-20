
set number
set tabstop=4
set shiftwidth=4
set expandtab

set background=dark
colorscheme nord

call plug#begin('~/.local/share/nvim/plugged')
	Plug 'christoomey/vim-system-copy'
call plug#end()

let g:system_copy#copy_command='<COPYBIN>'
let g:system_copy#paste_command='<PASTEBIN>'


