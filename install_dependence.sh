#!/bin/bash

function initialize {
  sudo apt-get update
  sudo apt-get install curl
  sudo apt-get install git
}

# Install UI
function install_theme {
  sudo add-apt-repository ppa:numix/ppa
  sudo apt-get update
  sudo apt-get install numix-gtk-theme numix-icon-theme-circle
  git clone https://github.com/powerline/fonts.git
  ~/fonts/.install.sh
  echo "Powerline fonts was installed. Please change font on terminal setting!!!"
  sudo apt-get install unity-tweak-tool
  gsettings set org.gnome.desktop.interface gtk-theme "Numix"
  gsettings set org.gnome.desktop.interface icon-theme 'Numix-circle'
  gsettings set org.gnome.desktop.wm.preferences theme "Numix"
}

# Install zsh and oh-my-zsh
function install_zsh {
  echo "Installing zsh and oh-my-zsh..."
  sudo apt-get install zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  sudo chsh -s /usr/bin/zsh
  git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
}

# Install vim and tmux
function install_vim_and_tmux {
  echo "Installing tmux 2.0 and vim."
  sudo apt-get install vim
  sudo add-apt-repository ppa:pi-rho/dev
  sudo apt-get update
  sudo apt-get install tmux
  sudo apt-get install vim
  sudo apt-get install vim-gnome
  sudo apt-get install xclip
  sudo apt-get install exuberant-ctags
  sudo curl -fsSL https://raw.github.com/mislav/dotfiles/1500cd2/bin/tmux-vim-select-pane \
    -o /usr/local/bin/tmux-vim-select-pane
  sudo chmod +x /usr/local/bin/tmux-vim-select-pane
}

# Download .dotfile and install
function config_dotfile {
  echo "Config dotfile "
  git clone https://github.com/ttuan/dotfile.git
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  cp dotfile/vimrc ~/.vimrc
  vim +PluginInstall +qall
  cp dotfile/getSongName.sh ~/getSongName.sh
  cp dotfile/zshrc ~/.zshrc
  cp dotfile/vimperatorrc ~/.vimperatorrc
  cp dotfile/tmux.conf ~/.tmux.conf
  cp dotfile/ctags ~/.ctags
  cp dotfile/Xmodmap ~/.Xmodmap
  cp gitconfig ~/.gitconfig
  cp gitignore ~/.gitigrnore
  xmodmap ~/.Xmodmap
  export EDITOR='vim'
  mkdir ~/.tmuxinator
  cp dotfile/project.yml ~/.tmuxinator/

  cd ~/.vim/bundle/YouCompleteMe
  ./install.py --clang-completer
}

# Install for web dev
function install_ruby_on_rails {
  echo "Installing ruby and rails"
  sudo apt-get update
  sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev

  sudo apt-get install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  curl -sSL https://get.rvm.io -ip4 | bash -s stable
  source ~/.rvm/scripts/rvm
  rvm install 2.3.1
  rvm use 2.3.1 --default
  ruby -v
  gem update --system
  echo "gem: --no-document" >> ~/.gemrc
  gem install bundler

  echo "Install mysql"
  sudo apt-get install mysql-server mysql-client libmysqlclient-dev

  gem install nokogiri
  gem install tmuxinator
  sudo apt-get install nodejs
  "Done! Rails 5 is not installed."
}

function programs {
  sudo apt-get install guake
  sudo apt-get install flashplugin-installer
  sudo apt-get install xpad
  sudo apt-get install nautilus-dropbox
}

initialize
install_theme
install_zsh
install_ruby_on_rails
config_dotfile
install_vim_and_tmux
programs
