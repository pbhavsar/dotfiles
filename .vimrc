set nocompatible	" Use Vim defaults (much better!)
" Required Vundle setup
filetype off
set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

call vundle#end()

syntax on
syntax enable
set background=dark
set t_Co=256
let g:solarized_termcolors = 16
colorscheme solarized
set backup
set backupdir=~/.vim/backup

set encoding=utf-8
set bs=indent,eol,start		" allow backspacing over everything in insert mode
set ai			" always set autoindenting on
set backup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set wrap linebreak textwidth=0
set nowrap
set esckeys " Exit insert mode instantly when ESC is pressed
set timeoutlen=1000 ttimeoutlen=0 " Exit visual mode instantly when ESC is pressed
set hidden
set autowrite
" Bash autocompletion
set wildmode=longest,list,full
set wildmenu
set noswapfile  " Bane of my existence, stop those damn "This file is being edited" errors


" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup fedora
  autocmd!
  " In text files, always limit the width of text to 78 characters
  " autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  " don't write swapfile on most commonly used directories for NFS mounts or USB sticks
  autocmd BufNewFile,BufReadPre /media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp
  " start with spec file template
  autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec
  augroup END
endif

if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  syntax enable
  set hlsearch
  set incsearch
endif

filetype plugin on

if &term=="xterm"
     set t_Co=8
     set t_Sb=[4%dm
     set t_Sf=[3%dm
endif

" Don't wake up system with blinking cursor:
" http://www.linuxpowertop.org/known.php
let &guicursor = &guicursor . ",a:blinkon0"

" CUSTOM SETTINGS

" General
set mouse=a "use mouse everywhere
set relativenumber  "turn on line numbers
set ruler   "Always show current positions along the bottom
set showcmd "show the command being typed

set laststatus=2
set statusline=%f "tail of filename
set statusline+=\ \[%{&ff}] "file format
set statusline+=%h "help file flag
set statusline+=%m "modified flat
set statusline+=%r "read only flag
set statusline+=%y "filetype
set statusline+=%= "left/right separator
set statusline+=%l/%L "cursor line/total line
set statusline+=\ %P "percent through file

" Searching
set ignorecase
set smartcase

" Tabs
set tabstop=4
set shiftwidth=4
set expandtab
set list listchars=tab:»·,trail:·

" File Extensions
au BufNewFile,BufRead *.hql set filetype=sql
au BufNewFile,BufRead *.html set filetype=htmldjango.html
au BufNewFile,BufRead *.less set filetype=css
au BufNewFile,BufRead *.scss set filetype=sass
au BufNewFile,BufRead *.sls set filetype=salt
au BufNewFile,BufRead *.mustache set filetype=mustache.html
au BufNewFile,BufRead *.tsv set filetype=tsv


" Change tab width depending on type (e.g. 4 for python, 2 for ruby)
autocmd FileType ruby,htmldjango.html,mustache.html,html.handlebars setlocal shiftwidth=2 tabstop=2
autocmd FileType python setlocal shiftwidth=4 tabstop=4
autocmd FileType coffee setlocal shiftwidth=2 tabstop=2
autocmd FileType json setlocal shiftwidth=2 tabstop=2
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType javascript.jsx setlocal shiftwidth=2 tabstop=2
autocmd FileType css setlocal shiftwidth=2 tabstop=2
autocmd FileType sass setlocal shiftwidth=2 tabstop=2
autocmd FileType salt setlocal shiftwidth=2 tabstop=2
autocmd FileType tsv setlocal noexpandtab shiftwidth=20 tabstop=20  " Disable tab-to-spaces for tsv's

" Fold settings
autocmd BufNewFile,BufReadPost *.coffee setl foldmethod=indent
autocmd BufNewFile,BufRead *.coffee :normal zR
set foldlevelstart=99

" ==========================
" ---------MAPPINGS---------
" ==========================

" Map up/down to next/prev buffer 
map <up> <ESC>:bn<RETURN> 
map <down> <ESC>:bp<RETURN> 
" Map left/right to prev/next tab
map <left> <ESC>gT 
map <right> <ESC>gt 

" Use CTRL-hjkl to move around windows
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-l> :wincmd l<CR>

" Movement Mappings
nnoremap j gj
nnoremap k gk

" Break line at cursor
nnoremap K i<CR><Esc>

" Paste Mappings
map <Leader>y "+y
map <Leader>p "+p
map <Leader>P "+P

" Relative/Absolute line numbers
function! NumberToggle()
    if(&relativenumber == 1)
        set number
    else
        set relativenumber
    endif
endfunc

" C-n to toggle relative/absolute line numbers
nnoremap <silent> <C-n> :call NumberToggle()<CR>
:nmap <C-e> :e#<CR>

" Save and Quit maps
" Got tired of accidentally hitting :Q and vim yelling at me
:command W w
:command Q q

" Build js files
:map <Leader>s :!gulp build<CR>

" Tab mappings
nmap <tab> >>
nmap <S-tab> <<

" Like bufdo but restore the current buffer and refresh ctrl-p.
function! BufDo(command)
  let currBuff=bufnr("%")
  execute 'bufdo ' . a:command
  execute 'buffer ' . currBuff
  " Refresh ctrl p
  execute 'CtrlPClearCache'
endfunction
com! -nargs=+ -complete=command Bufdo call BufDo(<q-args>)
" Shortcut for refreshing vim
nnoremap <Leader>R :Bufdo all<CR>

" Disable ex mode
:nnoremap Q <Nop>

" ==========================
" ---------PLUGINS----------
" ==========================

" ----------Ack-------------
" By default, don't open first result in buffer
ca Ack Ack!
" Ack for the currently highlighted text
nnoremap <Leader>a :Ack! 
xnoremap <Leader>a y:Ack! <C-r>=fnameescape(@")<CR><CR>

" Ctrl-P 
nnoremap <silent> <Leader>t :CtrlP<CR>
nnoremap <silent> <Leader>T :CtrlPBuffer<CR>
"nnoremap ; :CtrlPBuffer<CR>
let g:ctrlp_custom_ignore = '\.(pyc)|public/static/*$|node_modules/*$'
set wildignore+=*.pyc
set wildignore+=*/providermatch_admin/public/*
set wildignore+=*/node_modules/*

" NERDTree shortcut
nnoremap <silent> <Leader>nt :NERDTree<CR>
nnoremap <Leader>e :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$'] " ignore certain file extensions

" Bufexplorer customizations
let g:bufExplorerShowRelativePath=1
let g:bufExplorerSortBy='fullpath'
let g:bufExplorerSplitOutPathName=0

" Python-mode custom settings
"set completeopt-=preview  " Don't show docs in scratch window when autocompleting
"let g:pymode_doc=0  " Disable pymode documentation
"let g:pymode_doc_bind = "<C-S-d>"
"let g:pymode_rope=0  " Disable rope autocompletion
"let g:pymode_rope_completion = 0  " Disable rope autocompletion
"let g:pymode_lint=0
"" let g:pymode_lint_checkers=['pyflakes', 'mccabe']
"let g:pymode_breakpoint_bind='\br'
"let g:pymode_options_max_line_length = 119
"let g:python_comment_text_width = 120
"let g:pymode_lint_cwindow = 0

" If you prefer the Omni-Completion tip window to close when a selection is
" made, these lines close it on movement in insert mode or when leaving
" insert mode
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" Syntastic
let g:syntastic_enable_signs=1
let g:synastic_enable_highlighting=1
let g:syntastic_ruby_exec='~/.rvm/rubies/ruby-2.0.0-p247/bin/ruby'
let g:syntastic_python_checkers=['python', 'flake8', 'pep8', 'pyflakes']
let g:syntastic_python_flake8_args="--max-line-length=120"

" Vim-Coffee-Script
autocmd BufNewFile,BufReadPost *.coffee setl foldmethod=indent nofoldenable " Fold by indentation

" Vim-Ruby
let g:rubycomplete_buffer_loading = 1 "load/eval code to provide completions
let g:rubycomplete_classes_in_global = 1 "parse entire buffer to add classes to completion results

" Vim-Fugitive
set diffopt+=vertical " make diffs open vertically instead of horizontally (ew)

" Vim-Airline
let g:airline_section_z = '%l/%L'
let g:airline_section_y = '%Y'
let g:airline_section_x = ''
let g:airline_left_sep=''
let g:airline_right_sep=''

" Jedi-Vim
autocmd FileType python setlocal completeopt-=preview
let g:jedi#use_tabs_not_buffers=0
let g:jedi#popup_select_first=1
let g:jedi#show_call_signatures=0
let g:jedi#documentation_command = ""

" Supertab
let g:SuperTabDefaultCompletionType = "<c-n>"
