# This script will sync newest config file in dotfile folder with local config
# file

#!/bin/bash

#\\ Variables
DOTFILE=/home/$USER/Dropbox/Projects/dotfile
OLDDIR=/home/$USER/.old_dotfiles

#\\ Create folder to store all old dotfiles
mkdir -p ~/.old_dotfiles

#\\ Move dotfiles to old dir and create symlink for theme

# Vim
mv ~/.vimrc $OLDDIR 1&>2
ln -s $DOTFILE/vim/vimrc ~/.vimrc

# Ack
mv ~/.ackrc $OLDDIR 1&>2
ln -s $DOTFILE/vim/ackrc ~/.ackrc

# Git
mv ~/.gitconfig $OLDDIR 1&>2
mv ~/.gitignore $OLDDIR 1&>2
ln -s $DOTFILE/git/gitconfig ~/.gitconfig
ln -s $DOTFILE/git/gitignore ~/.gitignore

# i3
mv ~/.i3/config $OLDDIR 1&>2
ln -s $DOTFILE/i3/config ~/.i3/config

# CTags
mv ~/.ctags $OLDDIR 1&>2
ln -s $DOTFILE/tags/ctags ~/.ctags

# Tmux
mv ~/.tmux.conf $OLDDIR 1&>2
ln -s $DOTFILE/tmux/tmux.conf ~/.tmux.conf

# Tmuxinator
mv ~/.tmuxinator/project.yml $OLDDIR 1&>2
ln -s $DOTFILE/tmuxinator/project.yml ~/.tmuxinator/project.yml

# Vimperator
mv ~/.vimperatorrc $OLDDIR 1&>2
ln -s $DOTFILE/vimperator/vimperatorrc ~/.vimperatorrc

# Zsh
mv ~/.zshrc $OLDDIR
ln -s $DOTFILE/zsh/zshrc ~/.zshrc
