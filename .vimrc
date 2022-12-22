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
let lsp_diagnostics_signs_enabled = 0
let g:lsp_diagnostics_highlights_enabled = 0
let g:lsp_diagnostics_virtual_text_delay = 100
let g:lsp_diagnostics_virtual_text_prefix = ""
let g:lsp_diagnostics_virtual_text_enabled = 1
let g:lsp_signature_help_enabled = 0
let g:lsp_document_highlight_enabled = 0
let g:lsp_completion_documentation_enabled = 0
function! s:on_lsp_buffer_enabled() abort
  let g:lsp_format_sync_timeout = 1000
  autocmd! BufWritePre *.c,*.cpp,*.h,*tex call execute('LspDocumentFormatSync')
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

" SECTION: texlab
if executable('texlab')
  autocmd User lsp_setup call lsp#register_server({
      \'name': 'texlab',
      \'cmd': {server_info->[expand('texlab')]},
      \'whitelist': ['tex']
    \})
endif

" SECTION: pdflatex
if executable('pdflatex')
  autocmd BufWritePost *.tex term ++close ++hidden pdflatex %
endif

" SECTION: asyncomplete
let g:asyncomplete_auto_completeopt = 0
set completeopt=menuone,noinsert,preview
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<CR>"

" SECTION: vsnip
imap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
