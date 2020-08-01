" This is a basic configuration file for the Vim text editor. It's normally
" installed to `~/.vimrc` or can be included from there using
" `source ~/configs/.vimrc`.

" Don't use Vi compatibility mode
set nocompatible

" Enable syntax highlighting
syntax on

" Allow backspace over autoindent, line breaks, and start of insert
set backspace=indent,eol,start

" Highlight all search matches
set hlsearch

" Only insert one space after periods when joining lines
set nojoinspaces

" Show line numbers
set number

" Show the cursor position (line and column)
set ruler

" Create new split windows below/right of existing
set splitbelow
set splitright

" When tab-completing things, list all matches and complete through the common
" prefix
set wildmode=list:longest
