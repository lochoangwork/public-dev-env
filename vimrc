set encoding=utf-8
set backspace=indent,eol,start " allow backspacing over everything in insert mode

set nobackup    " do not keep a backup file, use versions instead
set history=10000
set ruler   " show the cursor position all the time
set showcmd   " display incomplete commands

" Don't use Ex mode, use Q for formatting
map Q gq

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Set tab space to 2.
set tabstop=2
" for the >> and << commands
set shiftwidth=2
" No word wrapping by default
set nowrap

" Make tabs visible
" set listchars=tab:>-,trail:-

set expandtab " Changes tabs to spaces
set autoindent " Autoindent for convinience
set confirm " Ask if wish to save files
set cmdheight=1 " Command window to 1 lines
"set autochdir " auto changes working dir depending on file
set ignorecase " case insenstive search
set smartcase " case senstive search if mixed case term
set showmatch " shows the match of a brace
set matchtime=2 " make showmatch happen faster
set wildmenu " tab completion for command line commands
set updatetime=450 " plugins run every 450
set noerrorbells
set visualbell
set wildmode=longest,full
set nofoldenable " folds off by default
"set number  line numbers
set hidden " lets me switch to another buffer without saving it as long as it lives as a buffer
set dir=~/tmp,/var/tmp,/tmp,.  " prefer swapfiles on local directories to avoid NFS problems
set foldmethod=indent   " fold based on indent
set foldnestmax=3       " set deepest fold
set shortmess+=I        " disable startup messge
set shortmess+=c        " disable ins-completion-menu messages

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " various autoindent things like for comments and such
  filetype plugin indent on
  " Wraps text files
  autocmd FileType text setlocal wrap
  autocmd FileType text setlocal linebreak
  " spell check for tex and git commit
  autocmd FileType gitcommit setlocal spell textwidth=72
  autocmd FileType tex setlocal spell spelllang=en_us
  autocmd FileType text setlocal spell spelllang=en_us
endif " has("autocmd")

set background=dark

" Makes it so vim picks up on ctags
set tags=tags;/

" downloads the plugin manager for vim
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" run PlugInstall to install missing ones
call plug#begin('~/.vim/bundle')
Plug 'neoclide/coc.nvim', {'branch': 'release'} " LSP engine
Plug 'ctrlpvim/ctrlp.vim' " fuzzy finder for finding things; similar to fzf, useful for files + buffers
Plug 'majutsushi/tagbar' " tag navigation
Plug 'chrisbra/unicode.vim' " unicode support
Plug 'preservim/nerdtree' " file tree exploration
Plug 'junegunn/fzf' " fuzzy find
Plug 'junegunn/fzf.vim' " fuzzy find for vim (builds on top of fzf)
Plug 'junegunn/gv.vim' " git log on the file with :GV
Plug 'tpope/vim-rhubarb' " github
Plug 'tpope/vim-fugitive' " git
Plug 'tpope/vim-unimpaired' " commands using [ and ]
Plug 'tpope/vim-abolish' " substitutions https://github.com/tpope/vim-abolish/blob/master/doc/abolish.txt
Plug 'tpope/vim-surround' " surroudings editing like braces, tags: ys -> you surround, cs changes, ds deletes
Plug 'tpope/vim-commentary' " comments with gc
Plug 'vim-airline/vim-airline' " nice status bar
Plug 'honza/vim-snippets' " snippets for use with coc snippets
Plug 'tpope/vim-repeat' " make it so you can use . to repeat more complicated things
Plug 'christoomey/vim-tmux-navigator' " vim-tmux integration + CTRL movement shortcuts for movement
Plug 'sheerun/vim-polyglot' " semantic syntax highlighting
Plug 'github/copilot.vim' " github AI assisted coding
call plug#end()

" get rid of warning on older vim/nvims for coc
" let g:coc_disable_startup_warning = 1

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes


" close current buffer but leave window intact for a vertical (A|B) split
map <leader>w :bp<bar>vsp<bar>bn<bar>bd<CR>
" close current buffer but leave window intact for a horizonal (A on top of B) split
map <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>

""""""
" vim airline (status bar)
""""""

" truncate branch name
let g:airline#extensions#branch#format = 2
" ignore expected format
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'

"+---------------------------------------------------------------------------+
"| A | B |                     C                          X | Y | Z |  [...] |
"+---------------------------------------------------------------------------+
" section truncation
" b, x, y z, warning, error
let g:airline#extensions#default#section_truncate_width = {
    \ 'b': 125,
    \ 'x': 140,
    \ 'y': 200,
    \ 'z': 45,
    \ 'warning': 180,
    \ 'error': 150,
    \ }

""""""
" Coc
""""""

let g:coc_global_extensions = ['coc-pyright', 'coc-clangd', 'coc-json', 'coc-snippets', 'coc-pyright', 'coc-tsserver', 'coc-eslint', 'coc-prettier', 'coc-emoji', 'coc-sql']

" use TAB as a replacement for C-n and C-p in navigation of the vim menu
" SID before check back space is to uniquely identifiy this file's
" check_back_space (see s: in front of it)
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ Check_back_space() ? "\<TAB>" :
      \ coc#refresh() " triggers/starts completion
" shift tab: move backwards
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" This func is called when tab is pressed outside of a menu; seems to
" check if the space before is a space
function! Check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion of a menu
" in regular vim this is worthless because c-@ isn't easily reachable
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current
" position.  Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    if CocAction('hasProvider', 'hover')
      call CocActionAsync('doHover')
    else
      call feedkeys('K', 'in')
    endif
  endif
endfunction

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Remap for do codeAction of current line
nmap <leader>ga <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>gf <Plug>(coc-fix-current)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>rf <Plug>(coc-refactor)
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" shortcut for coc command fuzzy finding
nmap <Leader>cc :CocCommand<CR>

" move between coc diagnostic errors
nmap <silent> ]c <Plug>(coc-diagnostic-next)
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]E <Plug>(coc-diagnostic-next-error)
nmap <silent> [E <Plug>(coc-diagnostic-prev-error)

""""""
" Coc-snippets
""""""
"
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
" disabled because tmux-vim intergration takes this bind
"vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)

""""""
" TagBar
""""""
nmap <F8> :TagbarToggle<CR>

"""""
" NerdTree
"""""
let NERDTreeWinPos = 'right'
nmap <F9> :NERDTreeToggle<CR>

"""""
" fzf
"""""

" Leader = \ unless mapleader is set to something else
nmap <Leader>fb :Buffers<CR>
nmap <Leader>fw :Windows<CR>
nmap <Leader>fl :BLines<CR>
nmap <Leader>ff :Files<CR>
nmap <Leader>fh :History:<CR>
nmap <Leader>fg :GFiles?<CR>


""""
" Copilot
""""

imap <silent><script><expr>  copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

imap <C-Up> <Plug>(copilot-previous)
imap <C-Down> <Plug>(copilot-next)
