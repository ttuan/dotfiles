#!/bin/bash

sudo add-apt-repository ppa:pi-rho/dev
sudo apt-get update
sudo apt-get install -y curl git zsh vim tmux xclip

sudo curl -fsSL https://raw.github.com/mislav/dotfiles/1500cd2/bin/tmux-vim-select-pane \
  -o /usr/local/bin/tmux-vim-select-pane
sudo chmod +x /usr/local/bin/tmux-vim-select-pane

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone git://github.com/zsh-users/zsh-autosuggestions /home/$USER/.oh-my-zsh/custom/plugins/zsh-autosuggestions

echo "Config dotfile "
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ln -sf vim/vimrc ~/.vimrc
vim +PlugInstall +qall
ln -sf zsh/zshrc ~/.zshrc
ln -sf tmux/tmux.conf ~/.tmux.conf
ln -sf git/gitconfig ~/.gitconfig
ln -sf git/gitignore ~/.gitigrnore

echo "Install docker and docker-compose"
wget -qO- https://get.docker.com/ | sh
COMPOSE_VERSION=`git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oP "[0-9]+\.[0-9][0-9]+\.[0-9]+$" | tail -n 1`
sudo sh -c "curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
sudo chmod +x /usr/local/bin/docker-compose
sudo sh -c "curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"
sudo usermod -aG docker $USER

sudo chsh -s /usr/bin/zsh
