#!/bin/bash

function initialize {
  sudo apt-get install -y software-properties-common
  sudo add-apt-repository ppa:pi-rho/dev
  sudo apt-get update
  sudo apt-get install -y curl git vim tmux
  sudo curl -fsSL https://raw.github.com/mislav/dotfiles/1500cd2/bin/tmux-vim-select-pane \
    -o /usr/local/bin/tmux-vim-select-pane
  sudo chmod +x /usr/local/bin/tmux-vim-select-pane

  git clone https://github.com/ttuan/dotfile.git
  cd ~/dotfile
  echo "Config dotfile "
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  cp ~/dotfile/vim/vimrc ~/.vimrc
  vim +PlugInstall +qall
  cp git/gitconfig ~/.gitconfig
  cp git/gitignore ~/.gitigrnore
}

# Install for web dev
function install_ruby_on_rails {
  echo "Installing ruby and rails"
  sudo apt-get update
  sudo apt-get install -y git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev \
    libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev \
    python-software-properties libffi-dev libgdbm-dev libncurses5-dev automake libtool bison libffi-dev

  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  curl -sSL https://get.rvm.io | bash -s stable
  source ~/.rvm/scripts/rvm
  rvm install 2.5.0
  rvm use 2.5.0 --default
  gem update --system
  echo "gem: --no-document" >> ~/.gemrc
  gem install bundler
  gem install nokogiri

  echo "Install mysql"
  sudo apt-get install -y  mysql-server mysql-client libmysqlclient-dev nodejs
  echo "Done! Rails 5 is installed."
}

function config_for_deploy {
  ssh-keygen -t rsa -b 4096 -C "tuantv.nhnd@gmail.com"
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa
  cat ~/.ssh/id_rsa.pub

  echo 'if [ -f ~/.env ]; then
        . ~/.env
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin:/home/deploy/deploy_bin"
' >> ~/.bashrc
  exec bash
  git clone REPO_URL
  localdeploy branch master
}

function autoremove {
  sudo apt-get -y autoremove
}

# initialize
# install_ruby_on_rails
config_for_deploy
# autoremove
