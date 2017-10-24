syntax enable
set background=dark

"{{{ Tabs and Whitespace
  set nocompatible
  set shiftwidth=2
  set tabstop=2
  set softtabstop=2
  set expandtab
  set list
  set listchars=tab:>-,trail:~,extends:>,precedes:<
"}}}

"{{{ UI Options
  set number
  set showcmd
  set cursorline
  filetype indent plugin on
  set wildmenu
  set showmatch
"}}}

"{{{ Autogroups
augroup configgroup
    autocmd!
    autocmd VimEnter * highlight clear SignColumn
    autocmd FileType php setlocal expandtab
    autocmd FileType php setlocal list
    autocmd FileType php setlocal listchars=tab:+\ ,eol:-
    autocmd FileType php setlocal formatprg=par\ -w80\ -T4
    autocmd BufEnter *.zsh-theme setlocal filetype=zsh
    autocmd BufEnter Makefile setlocal noexpandtab
    autocmd BufEnter *.sh setlocal tabstop=2
    autocmd BufEnter *.sh setlocal shiftwidth=2
    autocmd BufEnter *.sh setlocal softtabstop=2
augroup END
