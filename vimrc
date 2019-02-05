set encoding=utf-8
set fileencoding=utf-8

set backspace=indent,eol,start

execute pathogen#infect()

syntax on

set number
set background=dark

colorscheme codedark

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

" enable line numbers
let NERDTreeShowLineNumbers=1

let g:NERDTreeWinSize=50
" Start NERDTree
autocmd VimEnter * NERDTree
" Go to previous (last accessed) window.
autocmd VimEnter * wincmd p

set hidden " It hides buffers instead of closing them. This means that you can have
           " unwritten changes to a file and open a new file using :e, without being
           " forced to write or undo your changes first. Also, undo buffers and marks
           " are preserved while the buffer is open.
set nowrap " don't wrap lines

set ignorecase " ignore case when searching

set smartcase " ignore case if search pattern is all lowercase,
              " case-sensitive otherwise

set hlsearch " highlight search terms

set incsearch " show search matches as you type

set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo

set nobackup
set noswapfile

set list
set listchars=tab:>-,trail:•,extends:»,precedes:«,nbsp:¬
