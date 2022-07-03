set shell=/bin/sh

let mapleader = "\<space>"
let maplocalleader = "\<space>"

" escapes
imap jw <Esc>
imap wj <Esc>

" Clear all registers
command! WipeReg for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor

" Terminal ---------------------- {{{

" No linenumbers in terminal
au TermOpen * setlocal nonumber norelativenumber
" Autoinsert mode
autocmd BufEnter term://* startinsert
autocmd BufLeave term://* stopinsert
" Open, close, switch window, open in tab, switch tab
nnoremap <leader>tv :vs<CR>:terminal<CR>i
nnoremap <leader>ts :sp<CR>:terminal<CR>i
"nnoremap <leader>tt :tabedit<CR>:terminal<CR>i

tnoremap <C-q> <C-\><C-n>:bdelete!<CR>
tnoremap <C-w><C-w> <C-\><C-n><C-w><C-w>

" }}}

" Vim basic settings ---------------------- {{{

set encoding=utf-8
" Setup undofiles
set nobackup undofile
" check for external file changes when editing stops
au CursorHold,CursorHoldI * checktime
" Set numbers, scrolloffset
set ruler number relativenumber
set scrolloff=999
set autoindent smartindent
set tabstop=2 shiftwidth=2
set softtabstop=-1 shiftround expandtab
set cursorline
set cc=80
" window behavior
set splitright splitbelow
set switchbuf="vsplit"
" show matching paren on closing for n 10ths of second
set showmatch matchtime=1
" don't jump to begginning of line on page jumps
set nostartofline
" highlight search, incremental search
if &t_Co > 2 || has("gui_running")
    set hlsearch incsearch
endif
" enable syntax
syntax on
filetype on
filetype plugin indent on

" fuzzy
set path+=**
set wildmenu

" }}}

" Key mappings ---------------------- {{{

" write all
nnoremap <silent> <C-S> :<C-U>wa<CR>

" close current
fun! CloseCurrent()
    " let ntabs = call tabpagenr('$')
    " let nwins = call winnr('$')
    if &readonly || @% == "" || &buftype == 'nofile'
        :execute ':q'
    else
        :execute ':wq'
    endif
endfun
nnoremap <silent> <C-c> :<C-u>call CloseCurrent()<CR>
" close all auxiliary windows (quickfix, help, loclist, preview)
nnoremap <silent> <C-q> :<C-u>cclose<CR>:helpclose<CR>:lclose<CR>:pclose<CR>

" focus quickfix
nnoremap <silent> <leader>q :<C-u>copen<CR>

" Edit new file
nnoremap <leader>nn :<C-U>e<SPACE>
nnoremap <leader>ns <C-w><C-s>:<C-U>e<SPACE>
nnoremap <leader>nv <C-w><C-v>:<C-U>e<SPACE>
nnoremap <leader>nt :<C-U>tabedit<SPACE>

" cycle windows
fun! NextBufferWindow()
    let last = winnr('$')
    let current = winnr()
    let new = current + 1
    while new <= last
      " if not a special window
      let syntax = getwinvar(new, '&syntax')
      if (syntax != 'qf' && syntax != '')
        execute new.'wincmd w'
        return
      endif
      let new = new + 1
    endwhile
    let new = 1
    while new <= current
      " if not a special window
      let syntax = getwinvar(new, '&syntax')
      if (syntax != 'qf' && syntax != '')
        execute new.'wincmd w'
        return
      endif
      let new = new + 1
    endwhile
endfun
nnoremap <silent> <TAB> :<C-u>call NextBufferWindow()<CR>
nnoremap <silent> <C-TAB> <C-w><C-w>

" switch buffer
nnoremap <silent> <C-N> :w<CR>:bnext<CR>
nnoremap <silent> <C-P> :w<CR>:bprevious<CR>
" delete buffer + move to next
fun! BufferDeleteCurrent()
    if &readonly
        execute 'bprevious'
        execute 'bd#'
    else
        execute 'w'
        execute 'bprevious'
        execute 'bd#'
    endif
endfun
nnoremap <silent> <C-X> :call BufferDeleteCurrent()<CR>
" choose buffer
nnoremap <Leader>b :set nomore<Bar>:ls<Bar>:set more<CR>:b<Space>

" Use <C-L> to clear the highlighting of :set hlsearch.
nnoremap <silent> <C-L> :nohlsearch<CR><C-L>

" Search and Replace
nnoremap <Leader>sr :%s//g<Left><Left>

nnoremap Q @q

" Shift view by 5 lines
nnoremap <C-E> <C-E><C-E><C-E><C-E><C-E>
inoremap <C-E> <C-O><C-E><C-O><C-E><C-O><C-E><C-O><C-E><C-O><C-E>
nnoremap <C-Y> <C-Y><C-Y><C-Y><C-Y><C-Y>
inoremap <C-Y> <C-O><C-Y><C-O><C-Y><C-O><C-Y><C-O><C-Y><C-O><C-Y>

" }}}

" Filetype specific---------------------- {{{

" svelte
au! BufNewFile,BufRead *.svelte set ft=html
" vim
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType vim setlocal tabstop=4 shiftwidth=4 cc=0
augroup END
" gitcommit
augroup filetype_gitcommit
    autocmd!
    autocmd FileType gitcommit setlocal tw=72 spell wrap
augroup END
" markdown
augroup filetype_markdown
    autocmd!
    autocmd FileType markdown setlocal tw=72 spell wrap cc=120
    autocmd FileType markdown setlocal wrap wrapscan linebreak nolist spell

    autocmd FileType markdown nnoremap <buffer> j gj
    autocmd FileType markdown nnoremap <buffer> k gk
    autocmd FileType markdown nnoremap <buffer> 0 g0
    autocmd FileType markdown nnoremap <buffer> ^ g^
    autocmd FileType markdown nnoremap <buffer> $ g$

    autocmd FileType markdown vnoremap <buffer> j gj
    autocmd FileType markdown vnoremap <buffer> k gk
    autocmd FileType markdown vnoremap <buffer> 0 g0
    autocmd FileType markdown vnoremap <buffer> ^ g^
    autocmd FileType markdown vnoremap <buffer> $ g$
augroup END
" latex
augroup filetype_latex
  autocmd!
  autocmd FileType tex setlocal wrap wrapscan linebreak nolist spell

  autocmd FileType tex nnoremap <buffer> j gj
  autocmd FileType tex nnoremap <buffer> k gk
  autocmd FileType tex nnoremap <buffer> 0 g0
  autocmd FileType tex nnoremap <buffer> ^ g^
  autocmd FileType tex nnoremap <buffer> $ g$

  autocmd FileType tex vnoremap <buffer> j gj
  autocmd FileType tex vnoremap <buffer> k gk
  autocmd FileType tex vnoremap <buffer> 0 g0
  autocmd FileType tex vnoremap <buffer> ^ g^
  autocmd FileType tex vnoremap <buffer> $ g$
augroup END
let g:tex_flavor = "latex"
" racket
augroup filetype_racket
  autocmd!
  autocmd FileType racket let b:coc_pairs_disabled = ["'", "<"]
  autocmd FileType racket nmap <buffer> <CR> ysabba
augroup END
" lisp
augroup filetype_lisp
    autocmd!
    autocmd FileType lisp let b:coc_pairs_disabled = ["'", "<"]
    autocmd FileType lisp nmap <buffer> <CR> ysabba
augroup END
" c
augroup filetype_c
    autocmd!
    autocmd FileType c nnoremap <silent> <localleader>o :<C-u>CocCommand clangd.switchSourceHeader<CR>
    autocmd FileType cpp nnoremap <silent> <localleader>o :<C-u>CocCommand clangd.switchSourceHeader<CR>
 augroup END
" SQL
let g:omni_sql_no_default_maps = 1
" }}}

let g:local_config = $HOME . "/.config/nvim/local.vim"

" source local config, if exists
" leave at the end so defaults can be overridden
if filereadable(local_config)
    execute "source " . g:local_config
endif

nnoremap <silent> <leader>ev :<C-U>e ~/.config/nvim/local.vim<CR>
nnoremap <silent> <leader>ec :<C-U>e ~/.config/nvim/coc-settings.json<CR>

" re-source configuration
nnoremap <leader>sv :<C-U>source ~/.config/nvim/local.vim<CR>:nohlsearch<CR>
