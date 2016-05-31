execute pathogen#infect()

set number
set background=dark

" show trailing spaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

filetype plugin indent on

" control the number of space characters that will be inserted when the tab
" key is pressed
set tabstop=4
" change the number of space characters inserted for indentation
set shiftwidth=4
" insert space characters whenever the tab key is pressed
set expandtab

set runtimepath^=~/.vim/bundle/ctrlp.vim

set clipboard=unnamed

set hlsearch

" Start NERDTree
autocmd VimEnter * NERDTree
" Go to previous (last accessed) window.
autocmd VimEnter * wincmd p

set listchars=tab:▸\ ,eol:¬

