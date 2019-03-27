#!/bin/bash

# This script will sync newest config file in dotfiles folder with local config file

#\\ Variables
DOTFILES=/home/$USER/Dropbox/Projects/dotfiles
OLDDIR=/home/$USER/.old_dotfiles

#\\ Create folder to store all old dotfiles
mkdir -p ~/.old_dotfiles

#\\ Move dotfiles to old dir and create symlink for theme

# Vim
echo "Syn Vim config"
mv ~/.vimrc $OLDDIR 1&>2
ln -sf $DOTFILES/vim/vimrc ~/.vimrc

# Ack
echo "Syn Ack config"
mv ~/.ackrc $OLDDIR 1&>2
ln -sf $DOTFILES/vim/ackrc ~/.ackrc

# Git
echo "Syn Git config"
mv ~/.gitconfig $OLDDIR 1&>2
mv ~/.gitignore $OLDDIR 1&>2
ln -sf $DOTFILES/git/gitconfig ~/.gitconfig
ln -sf $DOTFILES/git/gitignore ~/.gitignore

# i3
echo "Syn i3 config"
mv ~/.i3/config $OLDDIR 1&>2
ln -sf $DOTFILES/i3/config ~/.i3/config

# CTags
echo "Syn CTags config"
mv ~/.ctags $OLDDIR 1&>2
ln -sf $DOTFILES/ctags/ctags ~/.ctags

# Tmux
echo "Syn Tmux config"
mv ~/.tmux.conf $OLDDIR 1&>2
ln -sf $DOTFILES/tmux/tmux.conf ~/.tmux.conf

# Tmuxinator
echo "Syn Tmuxinator config"
mv ~/.tmuxinator/project.yml $OLDDIR 1&>2
ln -sf $DOTFILES/tmuxinator/project.yml ~/.tmuxinator/project.yml

# Vimperator
echo "Syn Vimperator config"
mv ~/.vimperatorrc $OLDDIR 1&>2
ln -sf $DOTFILES/vimperator/vimperatorrc ~/.vimperatorrc

# Zsh
echo "Syn Zsh config"
mv ~/.zshrc $OLDDIR
ln -sf $DOTFILES/zsh/zshrc ~/.zshrc
