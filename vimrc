filetype off

" Plugins ----------------------------------------------------------------------
call plug#begin('~/.vim/plugged')
" General
Plug 'tpope/vim-sensible'
Plug 'rking/ag.vim'
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'edkolev/tmuxline.vim'
Plug 'bling/vim-airline'
Plug 'moll/vim-bbye'
Plug 'tpope/vim-surround'
Plug 'ryanoasis/vim-webdevicons'
Plug 'tpope/vim-obsession'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'terryma/vim-expand-region'
Plug 'jlanzarotta/bufexplorer'
Plug 'w0rp/ale'
Plug 'Chiel92/vim-autoformat'
Plug 'terryma/vim-smooth-scroll'
Plug 'xolox/vim-notes'
Plug 'xolox/vim-misc'
Plug 'RRethy/vim-illuminate'
Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'mbbill/undotree'
Plug 'vim-airline/vim-airline-themes'
Plug 'yangmillstheory/vim-snipe'
" Plug 'nathanaelkane/vim-indent-guides'
" Javascript
Plug 'Shutnik/jshint2.vim'
Plug 'pangloss/vim-javascript'
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'maksimr/vim-jsbeautify'
Plug 'ternjs/tern_for_vim'
Plug 'Quramy/vim-js-pretty-template'
" Java
Plug 'artur-shaik/vim-javacomplete2'
" Python
Plug 'fisadev/vim-isort'
Plug 'python-mode/python-mode', { 'branch': 'develop' }
" Other
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'JamshedVesuna/vim-markdown-preview'
call plug#end()

" Settings ------------------------------------------------------------------------------
filetype plugin indent on
syntax on
set omnifunc=syntaxcomplete#Complete
set expandtab                     " use spaces, not tab characters
set nocompatible                  " don't need to be compatible with old vim
set relativenumber                " show relative line numbers
set number
set showmatch                     " show bracket matches
set ignorecase                    " ignore case in search
set hlsearch                      " highlight all search matches
set cursorline                    " highlight current line
set smartcase                     " pay attention to case when caps are used
set incsearch                     " show search results as I type
set mouse=a                       " enable mouse support
set timeoutlen=200                " decrease timeout for faster <leader> commands
set ttimeoutlen=15                " decrease timeout for faster insert with 'O'
set vb                            " enable visual bell (disable audio bell)
set ruler                         " show row and column in footer
set scrolloff=2                   " minimum lines above/below cursor
set laststatus=2                  " always show status bar
set clipboard=unnamedplus         " use the system clipboard
set wildmenu                      " enable bash style tab completion
set wildmode=list:longest,full
set ts=4                          " set indent to 2 spaces
set shiftwidth=2
set regexpengine=2
set ts=4 sw=4 et
let g:notes_directories = ['/home/chris/google-drive/notes'] " vim-notes
set t_ut= " fix background colors
set splitbelow
set splitright
set backspace=indent,eol,start " backspace over anything in insert mode
hi Folded ctermbg=0
set viewoptions=cursor,folds,slash,unix 
let vim_markdown_preview_github=1

" Keybindings ------------------------------------------------------------------
command W w !sudo tee % >/dev/null
nnoremap <leader>c :noh<cr>
nnoremap <leader>e :try<bar>lnext<bar>catch /^Vim\%((\a\+)\)\=:E\%(553\<bar>42\):/<bar>lfirst<bar>endtry<cr>
nnoremap <leader>E :try<bar>lprev<bar>catch /^Vim\%((\a\+)\)\=:E\%(553\<bar>42\):/<bar>llast<bar>endtry<cr>
nnoremap <expr> k (v:count > 1 ? "m'" . v:count : '') . 'k'
nnoremap <expr> j (v:count > 1 ? "m'" . v:count : '') . 'j'
" Buffer Nav
map { :bp
map } :bn
nnoremap w :Bdelete<cr>
nnoremap W :bufdo :Bdelete<cr>
" Pane Nav
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h
" Nerdtree
nnoremap <leader>f  :NERDTreeFind<cr> 
nnoremap f  :NERDTreeFind<cr> 
nnoremap <A-f>  :NERDTreeFind<cr> 
nnoremap 1 :UndotreeHide<cr>:NERDTreeToggle<cr>
nnoremap <A-1> :NERDTreeToggle<cr>
" Spellcheck
nnoremap <leader>z :setlocal spell! spelllang=en_us<CR>
" Bufkill
map <leader>q :BD<CR>
set <a-s-w>=W
nnoremap <a-s-w> :Bufonly
" Undo
nnoremap <leader>u :GundoToggle<CR>
" Expand region
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)
" Filetype Associations --------------------------------------------------------
au BufRead,BufNewFile *.tmpl set filetype=spec
" Formatters
nmap =j :%!python -m json.tool<CR>
nmap =s 0dtS$2dF,xx:SQLUFormatter<CR>:%s/\\n/ /g<CR>
" Search and replace with /<string> cs n.n.n.
vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
    \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
omap s :normal vs<CR>

" Colors -----------------------------------------------------------------------
set background=dark
colorscheme base16-railscasts
highlight clear SignColumn
highlight VertSplit    ctermbg=236
highlight ColorColumn  ctermbg=237
highlight LineNr       ctermbg=236 ctermfg=240
highlight CursorLineNr ctermbg=236 ctermfg=240
highlight CursorLine   ctermbg=236
highlight IncSearch    ctermbg=0   ctermfg=3
highlight Search       ctermbg=0   ctermfg=9
highlight Visual       ctermbg=3   ctermfg=0
highlight Pmenu        ctermbg=240 ctermfg=12
highlight PmenuSel     ctermbg=0   ctermfg=3
highlight SpellBad     ctermbg=0   ctermfg=1
" Indent colors
let g:indent_guides_auto_colors = 0
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=241
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=235
" Cursor Color
let &t_SI = "\<Esc>]12;orange\x7"
if &term == 'xterm-256color' || &term == 'screen-256color'
    let &t_SI = "\<Esc>[5 q"
    let &t_EI = "\<Esc>[1 q"
endif

" NerdTree -------------------------------------------------------------------------------
nnoremap f 
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
:set hidden
let NERDTreeShowHidden = 0
let NERDTreeShowLineNumbers=1
let NERDTreeQuitOnOpen = 1
let NERDTreeMinimalUI = 1
let NERDTreeCascadeOpenSingleChildDir = 1
let NERDTreeWinSize = 50
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction
call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')

" vim-airline ------------------------------------------------------------------
let g:airline_theme = 'base16'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#bufferline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tmuxline#enabled = 0

" CtrlP File Nav ---------------------------------------------------------------
let g:ctrlp_by_filename = 1
let g:ctrlp_regexp = 0
let g:ctrlp_map = '<leader>t'
nnoremap <leader>m :CtrlPMRU<cr>
nnoremap <leader>b :CtrlPBuffer<cr>

" Ag search file contents ------------------------------------------------------
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif
" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
nnoremap  <leader>a :call AgWord()<CR>
nnoremap  <leader>aa :call AgLine()<CR>
function! AgWord()
  execute ":Ag '" . expand("<cword>") . "'"
endfunction
function! AgLine()
  execute ":Ag '" . getline(".") . "'"
endfunction

" Undotree ---------------------------------------------------------------------
let g:undotree_SetFocusWhenToggle = 1
nnoremap 2 :NERDTreeClose<cr>:UndotreeToggle<cr>
if has("persistent_undo")
    set undodir=~/.undodir/
    set undofile
endif

" vim-illuminate ---------------------------------------------------------------
let g:Illuminate_ftblacklist = ['nerdtree']
hi link illuminatedWord Visual
let g:Illuminate_ftHighlightGroups = {
      \ 'javascript': ['jsFuncArgs', 'jsObjectKey', 'jsFuncCall', 'jsParenIfElse', 'jsIfElseBlock', 'jsParen', 'PreProc', 'Number', 'String'],
      \ 'python': [''],
      \ 'Jenkinsfile': ['', 'Identifier'],
      \ 'vim': ['Identifier', 'vimMapRhs', 'Special', 'vimMapLhs', 'String']
      \ }
nnoremap <leader>it :echo synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name")

" Deoplete ---------------------------------------------------------------------
set pyxversion=3
set encoding=utf-8
let g:deoplete#enable_at_startup = 1

" Webdevicons ------------------------------------------------------------------
let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_enable_airline_tabline = 0
let g:webdevicons_enable_airline_statusline = 0

" Ultisnips --------------------------------------------------------------------
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsEditSplit="horizontal"

" Gvim -------------------------------------------------------------------------
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar

" Buffer Settings --------------------------------------------------------------
function! AutoSaveWinView()
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction
" Restore current view settings.
function! AutoRestoreWinView()
    let buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0
        if atStartOfFile && !&diff
            call winrestview(w:SavedBufView[buf])
        endif
        unlet w:SavedBufView[buf]
    endif
endfunction
" When switching buffers, preserve window view.
if v:version >= 700
    autocmd BufLeave * call AutoSaveWinView()
    autocmd BufEnter * call AutoRestoreWinView()
endif

" ale --------------------------------------------------------------------------
let g:ale_linters = {
  \  'javascript': ['eslint'],
  \  'yaml': ['swaglint'],
  \  'python': ['flake8']
\}
let g:ale_fixers = {
  \  'javascript': ['eslint'],
  \  'python': ['autopep8', 'isort']
\}
let g:ale_fix_on_save = 1
let g:ale_echo_msg_format = '%linter% says %s'
let g:ale_javascript_eslint_use_global = 1

" Pymode -----------------------------------------------------------------------
let g:pymode = 1
let g:pymode_options = 1
let g:pymode_quickfix_minheight = 3
let g:pymode_quickfix_maxheight = 6
let g:pymode_python = 'python'
let g:pymode_folding = 0
let g:pymode_breakpoint_bind = '<leader>p'
let g:pymode_lint_ignore = "E501, W"
let g:pymode_rope = 1
let g:pymode_rope_lookup_project = 0
let g:pymode_rope_show_doc_bind = '<C-c>d'
let g:pymode_rope_regenerate_on_write = 1
let g:pymode_rope_completion = 1
let g:pymode_rope_complete_on_dot = 1
let g:pymode_rope_completion_bind = '<C-Space>'
let g:pymode_rope_autoimport = 1
let g:pymode_rope_autoimport_after_complete = 0
let g:pymode_rope_goto_definition_bind = '<C-c>g'
let g:pymode_rope_goto_definition_cmd = 'e'
let g:pymode_syntax = 1
let g:pymode_syntax_slow_sync = 1
let g:pymode_syntax_all = 1

" Java -------------------------------------------------------------------------
autocmd FileType java setlocal omnifunc=javacomplete#Complete
let g:deoplete#omni_patterns = {}
let g:deoplete#omni_patterns.java = '[^. *\t]\.\w*'
let g:deoplete#auto_completion_start_length = 2
let g:deoplete#sources = {}
let g:deoplete#sources._ = []
let g:deoplete#file#enable_buffer_path = 1
nmap <F4> <Plug>(JavaComplete-Imports-AddSmart)
imap <F4> <Plug>(JavaComplete-Imports-AddSmart)
nmap <F5> <Plug>(JavaComplete-Imports-Add)
imap <F5> <Plug>(JavaComplete-Imports-Add)
nmap <F6> <Plug>(JavaComplete-Imports-AddMissing)
imap <F6> <Plug>(JavaComplete-Imports-AddMissing)
nmap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)
imap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)

" Javascript -------------------------------------------------------------------
let g:used_javascript_libs = 'underscore,angularjs,angularui'
nnoremap <leader>d :TernDef<cr>
let lint_default = 0

" project specific indentation TODO: move this to machine specific config ------
autocmd BufRead,BufNewFile /home/chris/dev/projects/active/insights-api/*.js setlocal ts=4 sw=4 et
autocmd BufRead,BufNewFile /home/chris/dev/projects/active/insights-frontend/*.js setlocal ts=4 sw=4 et
autocmd BufRead,BufNewFile /home/chris/dev/projects/active/insights/*.js setlocal ts=4 sw=4 et
autocmd BufRead,BufNewFile /home/chris/dev/projects/active/telemetryapi/*.js setlocal ts=4 sw=4 et
autocmd BufRead,BufNewFile /home/chris/dev/projects/active/*.js setlocal ts=4 sw=4 et

" end --------------------------------------------------------------------------
packloadall
silent! helptags ALL

set exrc
set secure

