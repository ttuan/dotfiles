" This space for Vundle :D
set nocompatible
filetype off 
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

Plugin 'Townk/vim-autoclose'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-repeat'

" Vim apperance
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'jpo/vim-railscasts-theme'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'mkitt/tabline.vim' " Show number of tab for quickly switch [number]gt

" Vim for ruby dev
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'mattn/emmet-vim'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-endwise'

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

call vundle#end()            
filetype plugin indent on

"\\
set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

"\\ Some Setting Extend
set relativenumber
set shell=bash
set autowrite

"\\ behavior
set nobackup
set nowritebackup
set noswapfile
set noundofile
autocmd BufLeave,FocusLost * silent! wall

"\\ encoding
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,sjis,euc-jp,default

"\\ appearance
set numberwidth=3
set t_Co=256
colorscheme railscasts 
set guifont=C@nsolas:h12:w6
set guifontwide=FixedSys:h18
set guioptions=egmrL

"\\ typing setting
set tabstop=2 shiftwidth=2 expandtab

"\\ mapping
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
nmap J <C-d>
nmap K <C-u>
map <F2> :bn<CR>
map <F3> :bp<CR>
map <Space> :noh<CR>

"\\ Language setting
nnoremap <buffer> <F9> :exec '!python' shellescape(@%, 1)<cr>

"\\ plugin mapping

" CtrlP map
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_user_command = 'find %s -type f'   

" Emmet-vim
imap hh <C-y>,

" NERDTree
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p
map <F5> :NERDTreeToggle<CR>
let g:nerdtree_tabs_open_on_console_startup=1

" Vim commentary
nmap cm gc

" Ruby text object
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

