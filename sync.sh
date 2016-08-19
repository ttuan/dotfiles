# This script will sync newest config file in dotfile folder with local config
# file

#!/bin/bash

DOTFILE=/home/$USER/Dropbox/Projects/dotfile
cp $DOTFILE/git/gitconfig ~/.gitconfig
cp $DOTFILE/git/gitignore ~/.gitignore
cp $DOTFILE/i3/config ~/.i3/config
cp $DOTFILE/tmux/tmux.conf ~/.tmux.conf
cp $DOTFILE/tmuxinator/project.yml ~/.tmuxinator/project.yml
cp $DOTFILE/vim/vimrc ~/.vimrc
cp $DOTFILE/vimperator/vimperatorrc ~/.vimperatorrc
cp $DOTFILE/zsh/zshrc ~/.zshrc
