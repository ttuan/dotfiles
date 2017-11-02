#!/bin/bash

function initialize {
  sudo apt-get update
  sudo apt-get install -y curl
  sudo apt-get install -y git
}

# Install UI
function install_theme {
  sudo add-apt-repository ppa:numix/ppa
  sudo apt-get update
  sudo apt-get install -y numix-gtk-theme numix-icon-theme-circle
  git clone https://github.com/powerline/fonts.git
  ~/fonts/.install.sh
  echo "Powerline fonts was installed. Please change font on terminal setting!!!"
  sudo apt-get install -y unity-tweak-tool
  gsettings set org.gnome.desktop.interface gtk-theme "Numix"
  gsettings set org.gnome.desktop.interface icon-theme 'Numix-circle'
  gsettings set org.gnome.desktop.wm.preferences theme "Numix"
  # ignore gnome draw desktop in i3
  gsettings set org.gnome.desktop.background show-desktop-icons false
}

# Install zsh and oh-my-zsh
function install_zsh {
  echo "Installing zsh and oh-my-zsh..."
  sudo apt-get install -y zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  sudo chsh -s /usr/bin/zsh
  git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

  # install FZF
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
}

# Install vim and tmux
function install_vim_and_tmux {
  echo "Installing tmux 2.0 and vim."
  sudo apt-get install -y vim
  sudo add-apt-repository ppa:pi-rho/dev
  sudo apt-get update
  sudo apt-get install -y tmux
  sudo apt-get install -y vim
  sudo apt-get install -y vim-gnome
  sudo apt-get install -y xclip
  sudo apt-get install -y exuberant-ctags
  sudo curl -fsSL https://raw.github.com/mislav/dotfiles/1500cd2/bin/tmux-vim-select-pane \
    -o /usr/local/bin/tmux-vim-select-pane
  sudo chmod +x /usr/local/bin/tmux-vim-select-pane
}

# Download .dotfile and install
function config_dotfile {
  cd ~/dotfile
  echo "Config dotfile "
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  cp dotfile/vimrc ~/.vimrc
  vim +PlugInstall +qall
  cp scripts/getSongName.sh ~/getSongName.sh
  cp zsh/zshrc ~/.zshrc
  cp vimperator/vimperatorrc ~/.vimperatorrc
  cp tmux/tmux.conf ~/.tmux.conf
  cp ctags/ctags ~/.ctags
  cp scripts/Xmodmap ~/.Xmodmap
  cp git/gitconfig ~/.gitconfig
  cp git/gitignore ~/.gitigrnore
  xmodmap ~/.Xmodmap
  export EDITOR='vim'
  mkdir ~/.tmuxinator ~/.i3
  cp i3/config ~/.i3/
  cp tmuxinator/project.yml ~/.tmuxinator/
}

# Install for web dev
function install_ruby_on_rails {
  echo "Installing ruby and rails"
  sudo apt-get update
  sudo apt-get install -y git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev

  sudo apt-get install -y libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
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
  gem install interactive_editor
  sudo apt-get install -y nodejs
  "Done! Rails 5 is not installed."
}

function programs {
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/adtac/climate/master/install)"
  sudo apt-get install -y i3
  sudo apt-get install -y irssi
  sudo apt-get install -y guake
  sudo apt-get install -y flashplugin-installer
  sudo apt-get install -y xpad
  sudo apt-get install -y nautilus-dropbox
  sudo apt-get install -y ncdu
  # Alfred like for Ubuntu
  sudo add-apt-repository ppa:nilarimogard/webupd8
  sudo apt-get install -y albert
  pip install git+https://github.com/gleitz/howdoi.git#egg=howdoi

  # Install translate tool
  git clone https://github.com/soimort/translate-shell
  cd translate-shell/
  make
  sudo make install

  # Ap-hotspot
  sudo add-apt-repository ppa:nilarimogard/webupd8
  sudo apt-get update
  sudo apt-get install -y ap-hotspot
  cd /tmp
  wget http://old-releases.ubuntu.com/ubuntu/pool/universe/w/wpa/hostapd_1.0-3ubuntu2.1_amd64.deb
  sudo dpkg -i hostapd*.deb
  sudo apt-mark hold hostapd
  sudo apt-get install -y xbacklight
}

initialize
install_theme
install_ruby_on_rails
config_dotfile
install_vim_and_tmux
programs
install_zsh
