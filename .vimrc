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

" Show some non-printable characters (like tabs)
set list
set listchars=tab:>-,trail:.,extends:>

" Only insert one space after periods when joining lines
set nojoinspaces

" Show line numbers
set number

" Show the cursor position (line and column)
set ruler

" Keep a few lines of margin above/below the cursor.
set scrolloff=3

" Create new split windows below/right of existing
set splitbelow
set splitright

" When tab-completing things, list all matches and complete through the common
" prefix
set wildmode=list:longest

" Make j and k respect line wrapping.
nmap j gj
nmap k gk

if has("gui_running")
  " Set theme
  colorscheme desert

  " Increase font size
  set guifont=Bitstream\ Vera\ Sans\ Mono\ 12

  " Resize main editor area when adding a tab bar, etc. This works better with
  " tiling window managers. Without this on Notion 4, if I open a new window,
  " open a second tab, and try to type a command with :, I can't see where I'm
  " typing.
  set guioptions+=k

  " Hide menu and toolbar
  set guioptions-=m
  set guioptions-=T

  " Make Ctrl-S save the current tab
  nmap <C-s> :w<CR>
  imap <C-s> <Esc><C-S>
endif
