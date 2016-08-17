" ============ General Config ===============

set nocompatible                         " Use Vim settings, rather than Vi settings.
filetype plugin indent on                " Load ftplugins and indent files
syntax on                                " Enable syntax highlighting

if has('unnamedplus')
  set clipboard=unnamed,unnamedplus      " Share clipboard between Vim and OS
endif

set number                               " Line number are good
set relativenumber                       " Relative number to quickly run command
set history=10000                        " Set command line history limit
set showcmd                              " Show incomplete commands at the bottom
set showmode                             " Show current mode at the bottom

"\\ encoding
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,sjis,euc-jp,default

set cursorline
set shell=zsh
set splitright
set splitbelow

"\\ search
set incsearch                            " Find the next match as we type the search
set hlsearch                             " Highlight searches by default
set ignorecase                           " Search case insensitive
set smartcase                            " But not when contain a uppercase char


"================ Vundle =====================

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Vim behavior plugin
Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'kien/ctrlp.vim'
Plugin 'rking/ag.vim'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'skwp/greplace.vim'
Plugin 'scrooloose/syntastic'
Plugin 'terryma/vim-expand-region'
Plugin 'Townk/vim-autoclose'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-repeat'

" Vim apperance
Plugin 'scrooloose/nerdtree'
Plugin 'jpo/vim-railscasts-theme'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'benmills/vimux'

" Vim motion
Plugin 'easymotion/vim-easymotion'
Plugin 'wikitopian/hardmode'

" Vim for ruby dev
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-bundler'
Plugin 'thoughtbot/vim-rspec'

" Vim for front-end dev
Plugin 'mattn/emmet-vim'

" More operator for vim
Plugin 'tpope/vim-surround'                     "s command like surround
Plugin 'vim-scripts/ReplaceWithRegister'        "gr to replace with yanked text

" Vim Text object
Plugin 'vim-scripts/argtextobj.vim'             "For function arguments: aa and ia
Plugin 'michaeljsmith/vim-indent-object'        "For ident object like python coffescript: ii and ai
Plugin 'kana/vim-textobj-user'                  "Addition to use vim text obj rubyblock
Plugin 'nelstrom/vim-textobj-rubyblock'         "Ruby text object: ir and ar
Plugin 'kana/vim-textobj-entire'                "Entire file: ae and ie
Plugin 'kana/vim-textobj-line'                  "Line textobj: al and il
Plugin 'whatyouhide/vim-textobj-erb'            "erb text obj: aE and iE

" Markdown
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'

" Ctags
Plugin 'craigemery/vim-autotag'

" Other Plugin
Plugin '907th/vim-auto-save'
call vundle#end()


" ================ Apperance ====================

set numberwidth=3
set t_Co=256
colorscheme railscasts
set guifont=C@nsolas:h12:w6
set guifont=inconsolata
set guifontwide=FixedSys:h18
set guioptions=egmrL
set tw=80
set showbreak=...                                 " Display ... as wrap break
set wrap linebreak nolist                         " Proper wrapping

"\\ Folding settings
" Use zi, za, zc, zR, zM, zv
set foldmethod=indent                             " Groups of lines with the same indent form a fold
set foldnestmax=3                                 " Set deepest folding to 3 levels
set nofoldenable                                  " Don't fold by default


" ================ Behavior =====================

"\\ Centralize backup, swap and undo file
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
	set undodir=~/.vim/undo
endif
set formatoptions-=cro

"\\ Auto save files
autocmd BufLeave, FocusLost * silent! wall         " Some terminal doesn't support FoucusLost
inoremap <Esc> <Esc>:w<CR>

"\\ Indentation settings
set tabstop=2 shiftwidth=2 expandtab autoindent

"\\ Allow backspacing over everything in insert mode
set backspace=indent,eol,start

"\\ ex_mode
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

"\\ Ignore redraw when using tmux
if &term =~ '256color'
  set t_ut=
endif


" ================ Mappings ====================

let mapleader=" " " Set Space for Leader key

"\\ Resizing Windows
nnoremap <Leader><Leader>= <C-w>=
nnoremap <Leader><Leader>k <C-w>+10
nnoremap <Leader><Leader>j <C-w>-10
nnoremap <Leader><Leader>h <C-w><10
nnoremap <Leader><Leader>l <C-w>>10

"\\ Switch between panels
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

"\\ Operator with a panel
nnoremap <Leader>t :tabnew<CR>
nnoremap <Leader>x :x<CR>
nnoremap <Leader>o :e<Space>
nnoremap <Leader>p o<ESC>p`[v`]

"\\ Disable arrow key
map <Left> :echo "no!"<cr>
map <Right> :echo "no!"<cr>
map <Up> :echo "no!"<cr>
map <Down> :echo "no!"<cr>


"\\ Quickly select text you just pasted
noremap gV `[v`]

"\\ Search
nnoremap <Leader>n :noh<CR>

"\\ Vim file
nmap <Leader>v :e ~/.vimrc<CR> " Quickly edit .vimrc file
noremap <Leader><Leader>s :so ~/.vimrc<CR> " Source .vimrc file

"\\ Switch between files
nnoremap <Leader><Leader>f :bp<CR> " Previous buffer file
nnoremap <Leader><Leader>b :bn<CR> " Next buffer file
nnoremap <Leader><Leader>c <c-^> " The last two files

"\\ Move a half page
nmap J <C-d>
nmap K <C-u>

"---------------  Make Vim like IDE -------------------------

"\\ Python
nnoremap <buffer> <F9> :exec '!python' shellescape(@%, 1)<cr>

"\\ C
nnoremap <Leader>i :!gcc -o .a.out % && ./.a.out<CR>

"\\ Ruby
" nmap <Leader>E :!ruby %<cr>


"=============== Extends behaviors =========================

"\\ Quick swap character, word and paragraph
nnoremap <silent> gw "_yiw:s/\(\%#\w\+\)\(\W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>
nnoremap <silent> gw "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>
nnoremap g{ {dap}p{

" Change cusor shape in different mode
au VimLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
au VimEnter * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"

"\\ Delete all trailing space when saving file
autocmd BufWritePre * :%s/\s\+$//e

"\\ Force save file when I forgot run 'sudo vim file'
cmap w!! %!sudo tee > /dev/null %


" ================ Plugin Config ====================

"\\ Vundle
nnoremap <Leader>P :so %<CR>:PluginInstall<CR>:q<CR> "Quickly install plugins

"------------------------------------------------------

"\\ CtrlP
nnoremap <Leader>. :CtrlPTag<cr>
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_user_command = 'find %s -type f'
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\.git$\|\.hg$\|\.svn$\|\.yardoc\|public\/images\|public\/system\|data\|log\|tmp$',
    \ 'file': '\.exe$\|\.so$\|\.dat$\|\.cache$'
\ }
if exists("g:ctrlp_user_command")
unlet g:ctrlp_user_command
endif
set wildignore+=*\\vendor\\**
let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("v")': ['<F2>', '<RightMouse>'],
    \ }

"------------------------------------------------------

"\\ Rails.vim
map <Leader>rg :Rgenerate
map <Leader>rd :Rdestroy

map <Leader>em :Emodel
map <Leader>ev :Eview
map <Leader>ec :Econtroller
map <Leader>eh :Ehelper
map <Leader>el :Elib
map <Leader>er :Emailer

map <Leader>ej :Ejavascript
map <Leader>es :Estylesheet
map <Leader>ey :Elayout

map <Leader>ee :Eenvironment
map <Leader>ei :Einitializer
map <Leader>ew :Emigration
map <Leader>ed :Eschema

map <Leader>ef :Efixtures
map <Leader>eu :Eunittest
map <Leader>et :Efunctionaltest

"------------------------------------------------------

"\\ Autosave
let g:auto_save = 1
let g:auto_save_silent = 1
let g:auto_save_in_insert_mode = 0

"------------------------------------------------------

"\\ Emmet-vim
imap hh <C-y>,

"------------------------------------------------------

"\\ NERDTree
map <F5> :NERDTreeToggle<CR>
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p

"------------------------------------------------------

"\\ Vim Commentary
nmap cm gc

"------------------------------------------------------

"\\ You Complete Me
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

"------------------------------------------------------

"\\ Ruby txet object
runtime macros/matchit.vim

"------------------------------------------------------

"\\ Syntastic
set statusline+=%#warningmsg#
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"------------------------------------------------------

"\\ Ack
let g:ag_working_path_mode="r"
set grepprg=ag
let g:grep_cmd_opts = '--line-numbers --noheading'

"------------------------------------------------------

"\\ UltiSnips
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<c-l>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

"------------------------------------------------------

"\\ Vim Hardmode
nnoremap <Leader>y <Esc>:call ToggleHardMode()<CR>

"------------------------------------------------------

"\\ Vim Airline
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

"------------------------------------------------------

"\\ Vim expand region
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)


"------------------------------------------------------

"\\ Easy Motion
let g:EasyMotion_do_mapping = 0
map <Leader> <Plug>(easymotion-prefix)
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)
nmap s <Plug>(easymotion-overwin-f2)
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>h <Plug>(easymotion-linebackward)

"------------------------------------------------------

"\\ RSpec.vim
nnoremap <Leader>rcs :call RunCurrentSpecFile()<CR>
nnoremap <Leader>ras :call RunAllSpecs()<CR>
map <Leader>rns :call RunNearestSpec()<CR>
map <Leader>rls :call RunLastSpec()<CR>


"------------------------------------------------------

"\\ Ctags
" autocmd BufWritePost *  :UpdateTags
" nnoremap <f5> :!ctags -R --exclude=.git --exclude=log *<cr>


" ================ My Extend Functions ====================

"\\ Auto refresh firefox active tab when I save a file, require refresh_browser.sh script

" autocmd BufWriteCmd *.html,*.css,*.rb,*.erb :call Refresh_browser()
function! Refresh_browser()
  if &modified
    write
    silent !refresh_firefox
  endif
endfunction

"\\ Auto close windows when COMMIT_EDITMSG git file --> Quickly push + rebase with git
function! Close_git_message()
  let l:filename = @%
  if (filename == ".git/COMMIT_EDITMSG")
    execute 'quitall'
  endif
endfunction
autocmd VimEnter * :call Close_git_message()
