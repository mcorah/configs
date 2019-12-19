
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

" set up python
let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3.6'

" Vundle
set nocompatible
filetype off

if has("nvim")
  call plug#begin('~/.vim/plugged')

  "Plugins ***************************
  Plug 'gmarik/vundle'
  Plug 'JuliaLang/julia-vim'
  Plug 'lervag/vimtex'

  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

  Plug 'vim-scripts/taglist.vim'
  Plug 'matze/vim-tex-fold'
  Plug 'w0rp/ale'

  " stuff for google code formatting
  Plug 'google/vim-maktaba'
  Plug 'google/vim-codefmt'
  Plug 'google/vim-glaive'

  call plug#end()
  call glaive#Install()
endif


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
  filetype plugin on
  filetype indent on

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

  " For all text files set 'textwidth' to 80 characters.
  autocmd FileType text setlocal textwidth=80

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

  " delete whitespace at end of line except for diffs which depend on whitespace
  autocmd BufWritePre *
    \ if expand('%:e') != 'diff' |
    \   :%s/\s\+$//e |
    \ endif

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

"folding
set foldmethod=syntax

"color lines past 80
set textwidth=80
hi ColorColumn guibg=#cccccc ctermbg=7
let &cc='+'.join(range(1,255),',+')

"thesaurus
" set thesaurus+=/home/micah/thesaurus/mthesaur.txt

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
map <leader>e :Explore<cr>
" disable banner (open with I)
let g:netrw_banner = 0
" tree style
let g:netrw_liststyle = 3
" Edit in the current pane
let g:netrw_browse_split = 0
" width fraction for window
let g:netrw_winsize = 25

" ale configs
map <leader>a :ALEToggle<cr>
" start ale disabled
let g:ale_enabled = 0

" google formatting configs
map <leader>fl :FormatLines<cr>
map <leader>fc :FormatCode<cr>

" Copy Paste
" from: https://www.reddit.com/r/neovim/comments/3fricd/easiest_way_to_copy_from_neovim_to_system/
" Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y

" Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" warn if not using nvim
if (! has('gui_running')) && (! has ('nvim')) && executable('nvim')
  :echom "Did you mean to use nvim?"
endif


" I've disabled plugins outside nvim. Set configs here.
if has('nvim')

  " deoplete general
  let g:deoplete#enable_at_startup = 1
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

  " I've pulled this regex from the master on vimtex
  " I believe matches get piped to vimtex.
  let g:vimtex#re#deoplete = '\\(?:'
        \ .  '\w*cite\w*(?:\s*\[[^]]*\]){0,2}\s*{[^}]*'
        "\ . '|(text|block)cquote\*?(?:\s*\[[^]]*\]){0,2}\s*{[^}]*'
        "\ . '|(for|hy)\w*cquote\*?{[^}]*}(?:\s*\[[^]]*\]){0,2}\s*{[^}]*'
        \ . '|\w*ref(?:\s*\{[^}]*|range\s*\{[^,}]*(?:}{)?)'
        \ . '|hyperref\s*\[[^]]*'
        \ . '|includegraphics\*?(?:\s*\[[^]]*\]){0,2}\s*\{[^}]*'
        \ . '|(?:include(?:only)?|input|subfile)\s*\{[^}]*'
        "\ . '|(usepackage|RequirePackage|PassOptionsToPackage)(\s*\[[^]]*\])?\s*\{[^}]*'
        \ . '|usepackage(\s*\[[^]]*\])?\s*\{[^}]*'
        "\ . '|documentclass(\s*\[[^]]*\])?\s*\{[^}]*'
        "\ . '|begin(\s*\[[^]]*\])?\s*\{[^}]*'
        "\ . '|end(\s*\[[^]]*\])?\s*\{[^}]*'
        "\ . '|\w*'
        \ .')'

  " deoplete for vimtex (instead of ycm)
  call deoplete#custom#var('omni', 'input_patterns', {
          \ 'tex': g:vimtex#re#deoplete
          \})

  " vimtex stuff

  " This addresses complaints about callbacks in vimtex
  let g:vimtex_compiler_latexmk = {
      \ 'backend' : 'process',
      \ 'background' : 1,
      \ 'build_dir' : '',
      \ 'callback' : 1,
      \ 'continuous' : 1,
      \ 'executable' : 'latexmk',
      \ 'options' : [
      \   '-pdf',
      \   '-shell-escape',
      \   '-verbose',
      \   '-file-line-error',
      \   '-synctex=1',
      \   '-interaction=nonstopmode',
      \ ],
      \}

  let g:vimtex_imaps_enabled = 0
  let g:vimtex_view_method='zathura'

  " Do not open the quickfix window automatically
  let g:vimtex_quickfix_mode = 0

  " bibtex configuration so that things are not insanely slow
  let g:vimtex_complete_enabled = 1
  let g:vimtex_complete_bib = { 'simple': 1 }
  let g:vimtex_complete_ignore_case = 1

  " vim-tex-fold configs
  " (align included bydefault)
  let g:tex_fold_additional_envs = [
    \ 'enumerate',
    \ 'itemize',
    \ 'align*', 'equation',
    \ ]
endif

" Modifications to syntax highlighting for diff mode
" highlight DiffAdd    cterm=bold ctermfg=none ctermbg=17 gui=none guifg=bg guibg=Red
" highlight DiffDelete cterm=bold ctermfg=none ctermbg=17 gui=none guifg=bg guibg=Red
" highlight DiffChange cterm=bold ctermfg=none ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffText   cterm=bold ctermfg=none ctermbg=131 gui=none guifg=bg guibg=Red

" remove that ugly extra space when joining lines
set nojoinspaces
