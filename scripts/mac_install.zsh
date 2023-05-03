function install_brew {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew install caskroom/cask/brew-cask
}

function terminal_install {
  brew install zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  export ZSH_CUSTOM=~/.oh-my-zsh
  git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

  brew install fzf
  # install shell extenstions
  /usr/local/opt/fzf/install

  brew cask install iterm2
}

function custom {
  git clone https://github.com/powerline/fonts.git
  ./fonts/.install.sh
  echo "Power line install done!"
  # Turn off startup sound
  sudo nvram SystemAudioVolume=%80
}

function dev_tools {
  brew install git the_silver_searcher tmux
  brew install vim --override-system-vim
  curl -fsSL https://raw.github.com/mislav/dotfiles/1500cd2/bin/tmux-vim-select-pane \
    -o /usr/local/bin/tmux-vim-select-pane
  chmod +x /usr/local/bin/tmux-vim-select-pane
}

function web_dev {
  brew install rbenv ruby-build commitizen peco

  # Add rbenv to bash so that it loads every time you open a terminal
  echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.zshrc
  source ~/.zshrc

  # Install Ruby
  rbenv install 2.4.0
  rbenv global 2.4.0
  ruby -v

  gem install rails -v 5.0.1
  rbenv rehash

  brew install mysql
  ln -sfv /usr/local/opt/mysql/*plist ~/Library/LaunchAgents
  launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
}

function programs {
  brew install ctags
  brew cask install --appdir="/Applications" google-chrome \
  firefox \
  dropbox \
  vlc \
  seil \
  macdown \
  spectacle \
  alfred \
  evernote \
  google-drive \
  bettertouchtool
}

# install_brew
terminal_install
custom
dev_tools
web_dev
