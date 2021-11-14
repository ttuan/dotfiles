"\\ Auto download and install plugins
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

"\\ Apperance
Plug 'scrooloose/nerdtree'
Plug 'morhetz/gruvbox'

"\\ Vim + Tmux
" Plug 'christoomey/vim-tmux-navigator' " Moving between tmux & vim: https://gist.github.com/mislav/5189704

call plug#end()

"==============================================================
"\\ NERDTree
map - :NERDTreeToggle<CR>
map ] :NERDTreeFind<CR>
" autocmd VimEnter * NERDTreeFind

