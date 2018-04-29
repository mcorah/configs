
" Micah Corah's vimrc file
"
" Derived initially from:
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2011 Apr 15
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.

" Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

"Plugins ***************************
Plugin 'gmarik/vundle'
Plugin 'JuliaLang/julia-vim'
Plugin 'lervag/vimtex'
Plugin 'Valloric/YouCompleteMe'
Plugin 'vim-scripts/taglist.vim'
Plugin 'matze/vim-tex-fold'
Plugin 'w0rp/ale'

" stuff for google code formatting
Plugin 'google/vim-maktaba'
Plugin 'google/vim-codefmt'
Plugin 'google/vim-glaive'

call vundle#end()
call glaive#Install()


if v:progname =~? "evim"
  finish
endif

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  filetype on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  "  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=200

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

  " delete whitespace at end of line
  autocmd BufWritePre * :%s/\s\+$//e
else

"  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif

" Filetype mappings
au BufNewFile,BufRead *.ino set filetype=cpp
au BufNewFile,BufRead *.tdl set filetype=cpp
au BufNewFile,BufRead *.xdr set filetype=cpp
au BufNewFile,BufRead *.launch set filetype=xml
au BufNewFile,BufRead *.yaml set filetype=yaml
au BufNewFile,BufRead *.xaml set filetype=xml
au BufNewFile,BufRead CMakeLists.txt set filetype=cmake
au BufNewFile,BufRead *.{cc,cxx,cpp,h,hh,hpp,hxx}.* set filetype=cpp

"micah's stuff
set shiftwidth=2
set softtabstop=2
set sw=2
set tabstop=2
set ts=2

set expandtab
set nu

"for vim-latex
filetype plugin on
filetype indent on
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_ViewRule_pdf='evince'

"folding
set foldmethod=syntax

"color lines past 80
set textwidth=80
hi ColorColumn guibg=#cccccc ctermbg=7
let &cc='+'.join(range(1,255),',+')

"thesaurus
" set thesaurus+=/home/micah/thesaurus/mthesaur.txt


"you complete me for vimtex
if !exists('g:ycm_semantic_triggers')
  let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers.tex = [
      \ 're!\\[A-Za-z]*(ref|cite)[A-Za-z]*([^]]*])?{([^}]*, ?)*'
      \ ]

"""""""""""
"
" Functions
"
"""""""""""

"automatic header gates

function! s:insert_gates()
  let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
  execute "normal! i#ifndef " . gatename
  execute "normal! o#define " . gatename . " "
  execute "normal! Go#endif /* " . gatename . " */"
  normal! kk
endfunction
autocmd BufNewFile *.{H,h,hpp} call <SID>insert_gates()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"keybindings
"leader
let maplocalleader = ','
let mapleader = ' '

"spell check
:map <leader>s :setlocal spell! spelllang=en_us<CR>

imap jk <Esc>

" Fix the difficult-to-read default setting for diff text highlighting.  The
" bang (!) is required since we are overwriting the DiffText setting. The highlighting
" for "Todo" also looks nice (yellow) if you don't like the "MatchParen" colors.
highlight! link DiffAdd DiffChange

"""""""""""""""""""""
" File explorer stuff
"""""""""""""""""""""

" file explorer (vertical split)
map <leader>e :Vexplore<cr>
" disable banner (open with I)
let g:netrw_banner = 0
" tree style
let g:netrw_liststyle = 3
" open in previous window
let g:netrw_browse_split = 4
" width fraction for window
let g:netrw_winsize = 25

" ale configs
map <leader>a :ALEToggle<cr>
" start ale disabled
let g:ale_enabled = 0

" google formatting configs
map <leader>fl :FormatLines<cr>
map <leader>fc :FormatCode<cr>

" This addresses complaints about callbacks in vimtex
let g:vimtex_compiler_latexmk = {'callback' : 0}
