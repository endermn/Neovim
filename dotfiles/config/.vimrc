set noswapfile
syntax enable
filetype plugin indent on
set mouse=a
set number
set signcolumn=yes
set updatetime=300

let g:ale_disable_lsp = 1
set clipboard=unnamedplus
call plug#begin('~/.config/nvim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/fzf.vim'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'
Plug 'rust-lang/rust.vim'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-fugitive'
Plug 'morhetz/gruvbox'
Plug 'dense-analysis/ale'
Plug 'frazrepo/vim-rainbow'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'Raimondi/delimitMate'
Plug 'mattn/emmet-vim'
call plug#end()

" set tabs to 2 spaces
set tabstop=8 softtabstop=0 expandtab shiftwidth=2 smarttab
"shows number of errors on status bar
function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    return l:counts.total == 0 ? 'OK' : printf(
        \   '%d⨉ %d⚠ ',
        \   all_non_errors,
        \   all_errors
        \)
endfunction
set statusline+=%=
set statusline+=\ %{LinterStatus()}
" enables rainbow brackets
let g:rainbow_active = 1
" disables auto saving for vim session
let g:session_autosave = 'no'
" auto formats files on save
let g:ale_fix_on_save = 1
" disable code folding
let g:vim_markdown_folding_disabled = 1

" Format
command! -nargs=0 Format :call CocAction('format')
" Smart wrapping
" enable indentation
set breakindent
" keeps indent level on line break
set breakindentopt=shift:2,min:40,sbr
" append '>>' to indent
set showbreak=>>
" highlight symbol
autocmd CursorHold * silent call CocActionAsync('highlight')

" deal with colors
if !has('gui_running')
  set t_Co=256
endif
if (match($TERM, "-256color") != -1) && (match($TERM, "screen-256color") == -1)
  " screen does not (yet) support truecolor
  set termguicolors
endif
set background=dark
let g:gruvbox_number_column = 'bg1'
autocmd vimenter * ++nested colorscheme gruvbox

" ctrl l to open nerd tree, and ctrl n to close
nnoremap <C-l> :NERDTreeMirror<CR>:NERDTreeFocus<CR>
nnoremap <C-n> :NERDTreeToggle<CR>
" for save session 
nnoremap <C-o> :OpenSession 
nnoremap <C-s> :SaveSession 
" remap esc in insert mode
inoremap <C-k> <ESC>

" Coc diagnostics
nmap <silent> cd :CocDiagnostics<CR>
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Coc navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> ga :CocAction<CR>

" tab for auto completion
inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
" tab for auto-import completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" esc to escape embedded terminal
tnoremap <Esc> <C-\><C-n>
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" WSL yank support
let s:clip = '/mnt/c/Windows/System32/clip.exe'
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
    augroup END
endif
