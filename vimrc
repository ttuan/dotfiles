" This space for Vundle :D
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Vim behavior plugin
Plugin 'VundleVim/Vundle.vim'
Plugin 'ervandew/supertab'
Plugin 'Valloric/YouCompleteMe'
Plugin 'kien/ctrlp.vim'
Plugin 'rking/ag.vim'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'skwp/greplace.vim'
Plugin 'scrooloose/syntastic'
Plugin '907th/vim-auto-save'
Plugin 'junegunn/fzf'

Plugin 'Townk/vim-autoclose'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-abolish' " :S/child{,ren}/adult{,s}/g
Plugin 'thinca/vim-quickrun'

" Vim apperance
Plugin 'altercation/solarized'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'jpo/vim-railscasts-theme'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'mkitt/tabline.vim' " Show number of tab for quickly switch [number]gt
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'benmills/vimux'

" Vim for ruby dev
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'mattn/emmet-vim'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-bundler'

" More operator for vim
Plugin 'tpope/vim-surround' "s command like surround
Plugin 'vim-scripts/ReplaceWithRegister' "gr to replace with yanked text
Plugin 'christoomey/vim-sort-motion' "gs to sort line

" Vim Text object
Plugin 'vim-scripts/argtextobj.vim' "For function arguments: aa and ia
Plugin 'michaeljsmith/vim-indent-object' "For ident object like python coffescript: ii and ai
Plugin 'kana/vim-textobj-user' "Addition to use vim text obj rubyblock
Plugin 'nelstrom/vim-textobj-rubyblock' "Ruby text object: ir and ar
Plugin 'kana/vim-textobj-entire' "Entire file: ae and ie
Plugin 'kana/vim-textobj-line' "Line textobj: al and il
Plugin 'whatyouhide/vim-textobj-erb' "erb text obj: aE and iE

" Compile
Plugin 'xuhdev/SingleCompile'


call vundle#end()
filetype plugin indent on

"\\
set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

"\\ Some Setting Extend
set number
set relativenumber
set cursorline
set shell=zsh
set autowrite
au FocusLost * :wa
set showcmd " Show what I'm typing
set splitright
set splitbelow
set history=10000
set ignorecase " Search case insensitive
set smartcase " But not when contain a uppercase char
autocmd BufWritePre * :%s/\s\+$//e " Delete all trailing space
nnoremap gf <C-W>f
vnoremap gf <C-W>f
set tw=80

"\\ behavior
set nobackup
set nowritebackup
set noswapfile
set noundofile
set formatoptions-=cro

autocmd BufLeave,FocusLost * silent! wall

"\\ encoding
set encoding=utf-8

set fileencodings=ucs-bom,utf-8,sjis,euc-jp,default

"\\ share clipboard
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif

"\\ appearance
set numberwidth=3
set t_Co=256
colorscheme railscasts
set guifont=C@nsolas:h12:w6
set guifont=inconsolata
set guifontwide=FixedSys:h18
set guioptions=egmrL

"\\ typing setting
set tabstop=2 shiftwidth=2 expandtab

"\\ ex_mode
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

"\\ mapping
set pastetoggle=<F10>
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
nmap J <C-d>
nmap K <C-u>
map <F2> :bn<CR>
map <F3> :bp<CR>
map <Space> :noh<CR>
map <enter> o<esc>
imap <C-o> <esc>o
map <M-t> :tabnew

"\\ Quick swap character, word and paragraph
nnoremap <silent> gw "_yiw:s/\(\%#\w\+\)\(\W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>
nnoremap <silent> gw "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>
nnoremap g{ {dap}p{

" Disable arrow key
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" Map to quickly switch tab
map 1t 1gt
map 2t 2gt
map 3t 3gt
map 4t gt

imap 1t <esc>1gt
imap 2t <esc>2gt

imap 3t <esc>3gt
imap 4t <esc>4gt

" Ignore redraw when using tmux
if &term =~ '256color'
  " disable Background Color Erase (BCE)
  set t_ut=
endif

"\\ Language setting
nnoremap <buffer> <F9> :exec '!python' shellescape(@%, 1)<cr>
set rtp+=~/.fzf

"\\ plugin mapping

" Vundle
" map :PI :so % | :PluginInstall

" CtrlP map
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


" Autosave
let g:auto_save = 1
" let g:auto_save_no_updatetime = 1
let g:auto_save_silent = 1
let g:auto_save_in_insert_mode = 0

" Emmet-vim
imap hh <C-y>,

" NERDTree
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p
map <F5> :NERDTreeToggle<CR>
" let g:nerdtree_tabs_open_on_console_startup=1

" Vim commentary
nmap cm gc

" You Complete Me
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

" Ruby txet object
runtime macros/matchit.vim

" Syntastic
set statusline+=%#warningmsg#
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Ack
let g:ag_working_path_mode="r"
set grepprg=ag
let g:grep_cmd_opts = '--line-numbers --noheading'

" Single Compile
map <c-e> :SCCompileRun<cr>
imap <c-e> <c-o>:SCCompileRun<cr>
map <F6> :SCViewResult<cr>
nnoremap <F10> :call SingleCompileSplit() \| SCCompileRun<CR>
 function! SingleCompileSplit()
    if winwidth(0) > 160
       let g:SingleCompile_split = "vsplit"
       let g:SingleCompile_resultsize = winwidth(0)/2
    else
       let g:SingleCompile_split = "split"
       let g:SingleCompile_resultsize = 15
    endif
 endfunction

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" Config for Vim Airline
let g:airline_powerline_fonts = 1
" let g:airline#extensions#tabline#enabled = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

"\\ Some extend functions
autocmd BufWriteCmd *.html,*.css,*.rb,*.erb :call Refresh_browser()
function! Refresh_browser()
  if &modified
    write
    silent !refresh_firefox
  endif
endfunction
