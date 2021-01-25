if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set relativenumber
set hidden
set nu
set nowrap
set nohlsearch
set noerrorbells
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set scrolloff=8
set noshowmode
set completeopt=menuone,noinsert,noselect
set colorcolumn=80
set signcolumn=yes
set background=dark
set nocompatible

call plug#begin('~/.config/nvim/plugged')
Plug 'nvim-telescope/telescope.nvim'
Plug 'gruvbox-community/gruvbox'
Plug 'jcherven/jummidark.vim'
Plug 'KarimElghamry/vim-auto-comment'
Plug 'sheerun/vim-polyglot'
call plug#end()

syntax enable
" vim-auto-vcomplete
let g:autocomment_map_keys = 0
colorscheme jummidark
highlight Normal guibg=none

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup RAINHEARDT
    autocmd!
    autocmd BufWritePre * :call TrimWhitespace()
augroup END

" Inline comment mapping
vnoremap <silent><C-_> :AutoInlineComment<CR>
nnoremap <silent><C-_> :AutoInlineComment<CR>
"
" Block comment mapping
vnoremap <silent><C-S-a> :AutoBlockComment<CR>
nnoremap <silent><C-S-a> :AutoBlockComment<CR>
