if has("nvim")
  call plug#begin('~/.vim/plugged')

  "Plugins ***************************
  Plug 'lervag/vimtex'

  call plug#end()
endif

let maplocalleader = ','
let mapleader = ' '

if has('nvim')

  let g:vimtex_view_method='zathura'

  " remotes!
  let g:vimtex_compiler_progname='nvr --servername ' . v:servername

endif
