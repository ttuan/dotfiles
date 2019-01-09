# This script will sync newest config file in dotfiles folder with local config
# file

#!/bin/bash

#\\ Variables
DOTFILES=/home/$USER/Dropbox/Projects/dotfiles
OLDDIR=/home/$USER/.old_dotfiles

#\\ Create folder to store all old dotfiles
mkdir -p ~/.old_dotfiles

#\\ Move dotfiles to old dir and create symlink for theme

# Vim
mv ~/.vimrc $OLDDIR 1&>2
ln -sf $DOTFILES/vim/vimrc ~/.vimrc

# Ack
mv ~/.ackrc $OLDDIR 1&>2
ln -sf $DOTFILES/vim/ackrc ~/.ackrc

# Git
mv ~/.gitconfig $OLDDIR 1&>2
mv ~/.gitignore $OLDDIR 1&>2
ln -sf $DOTFILES/git/gitconfig ~/.gitconfig
ln -sf $DOTFILES/git/gitignore ~/.gitignore

# i3
mv ~/.i3/config $OLDDIR 1&>2
ln -sf $DOTFILES/i3/config ~/.i3/config

# CTags
mv ~/.ctags $OLDDIR 1&>2
ln -sf $DOTFILES/tags/ctags ~/.ctags

# Tmux
mv ~/.tmux.conf $OLDDIR 1&>2
ln -sf $DOTFILES/tmux/tmux.conf ~/.tmux.conf

# Tmuxinator
mv ~/.tmuxinator/project.yml $OLDDIR 1&>2
ln -sf $DOTFILES/tmuxinator/project.yml ~/.tmuxinator/project.yml

# Vimperator
mv ~/.vimperatorrc $OLDDIR 1&>2
ln -sf $DOTFILES/vimperator/vimperatorrc ~/.vimperatorrc

# Zsh
mv ~/.zshrc $OLDDIR
ln -sf $DOTFILES/zsh/zshrc ~/.zshrc
