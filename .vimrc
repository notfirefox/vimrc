" SECTION: base
syntax on
filetype plugin indent on

" SECTION: background
set background=dark

" SECTION: numbering
set number relativenumber 

" SECTION: indentation
set autoindent expandtab smartindent shiftwidth=2 softtabstop=2 tabstop=2

" SECTION: wrapping
set nowrap

" SECTION: search
set incsearch 
set nohlsearch

" SECTION: hard mode
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

" SECTION: color column
set colorcolumn=90
highlight colorcolumn ctermbg=8

" SECTION: cursor shape
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
set ttyfast ttimeout ttimeoutlen=1

" SECTION: vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs ' ..
    \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" SECTION: plugins
call plug#begin()
  Plug 'lifepillar/vim-gruvbox8'
  Plug 'LunarWatcher/auto-pairs'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/vim-vsnip-integ'
call plug#end()

" SECTION: gruvbox
colorscheme gruvbox8

" SECTION: auto-pairs
let g:AutoPairsCompatibleMaps = 0
let g:AutoPairsMapBS = 1

" SECTION: vim-lsp
let g:lsp_semantic_enabled = 1
let g:lsp_semantic_delay = 100
let g:lsp_diagnostics_signs_enabled = 0
let g:lsp_diagnostics_highlights_enabled = 0
let g:lsp_diagnostics_virtual_text_delay = 100
let g:lsp_diagnostics_virtual_text_prefix = ""
let g:lsp_diagnostics_virtual_text_enabled = 1
let g:lsp_signature_help_enabled = 0
let g:lsp_document_highlight_enabled = 0
let g:lsp_completion_documentation_enabled = 0
function! s:on_lsp_buffer_enabled() abort
  let g:lsp_format_sync_timeout = 1000
  autocmd! BufWritePre *.c,*.cpp,*.h call execute('LspDocumentFormatSync')
endfunction
  augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" SECTION: clangd
if executable("clangd") == 0
  let s:clangdpath = expand("~/.clangd/bin")
  let $PATH .= ":" . s:clangdpath
endif
if executable('clangd')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'clangd',
    \ 'cmd': {server_info->['clangd', '-background-index']},
    \ 'whitelist': ['c', 'cpp', 'h'],
    \ })
endif

" SECTION: asyncomplete
let g:asyncomplete_auto_completeopt = 0
set completeopt=menuone,noinsert,preview

" SECTION: mapping functions
function! MapNext()
  if pumvisible()
    return "\<c-n>"
  elseif vsnip#jumpable(1)
    return "\<plug>(vsnip-jump-next)"
  else
    return "\<tab>"
  endif
endfunction
function! MapPrev()
  if pumvisible()
    return "\<c-p>"
  elseif vsnip#jumpable(-1)
    return "\<plug>(vsnip-jump-prev)" 
  else
    return "\<s-tab>"
  endif
endfunction
function! MapEnter()
  return pumvisible() ? asyncomplete#close_popup() : "\<cr>"
endfunction

" SECTION: completion mappings
inoremap <expr> <tab> MapNext()
inoremap <expr> <s-tab> MapPrev()
smap <expr> <tab> MapNext()
smap <expr> <s-tab> MapPrev()
inoremap <expr> <cr> MapEnter()
