#!/bin/bash

echo "🔧 Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
export PATH="/opt/homebrew/bin:$PATH"

echo "🔍 Updating Homebrew..."
brew update
brew upgrade

# --------------------------
# 🍺 Install GUI Applications
# --------------------------
echo "📦 Installing GUI apps..."

brew install --cask \
  appcleaner \
  obsidian \
  firefox \
  google-chrome \
  1password \
  messenger \
  notion \
  numi \
  openkey \
  iterm2 \
  postman \
  proxyman \
  slack \
  karabiner-elements \
  spotify \
  telegram \
  the-unarchiver \
  vlc \
  calibre \
  hiddenbar

# --------------------------
# 💻 Install CLI Tools
# --------------------------
echo "🛠 Installing CLI tools..."

brew install \
  php \
  cheat \
  joshmedeski/sesh/sesh \
  git \
  reattach-to-user-namespace \
  eza \
  fzf \
  ripgrep \
  tldr \
  mysql \
  redis \
  pyenv \
  commitizen \
  bat \
  yarn \
  tmux

# --------------------------
# 💡 Setup Zsh & Oh My Zsh
# --------------------------
echo "⚙️ Setting up Oh My Zsh..."

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Zsh Plugins
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Nerd Font for terminal
brew install --cask font-jetbrains-mono-nerd-font

# --------------------------
# 📦 Install Node.js via NVM
# --------------------------
echo "📦 Installing Node.js..."

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"
nvm install 22

# --------------------------
# 🐍 Python Packages
# --------------------------
pip3 install powerline-status

# --------------------------
# 🪟 Tmux Configuration
# --------------------------
echo "🔧 Setting up Tmux..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# --------------------------
# 🐳 Docker & DevOps Tools
# --------------------------
echo "🐳 Installing Docker tools..."

brew install docker docker-compose colima

# --------------------------
# 🪟 Window Manager: yabai + skhd
# --------------------------
brew install koekeishiya/formulae/skhd
skhd --start-service

brew install koekeishiya/formulae/yabai
yabai --start-service

# --------------------------
# ☁️ AWS Vault
# --------------------------
brew install aws-vault

# --------------------------
# 💎 Install RVM & Ruby
# --------------------------
echo "💎 Installing RVM and Ruby..."

gpg --keyserver keyserver.ubuntu.com \
    --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
                7D2BAF1CF37B13E2069D6956105BD0E739499BDB

\curl -sSL https://get.rvm.io | bash

source ~/.rvm/scripts/rvm
rvm install 3.1.3 --with-openssl-dir=$(brew --prefix openssl@3)

# --------------------------
# ☁️ Manual Reminders
# --------------------------
echo "📝 Please remember to manually install & sign in to:"
echo " - Dropbox"
echo " - Spectacle (if still used) or Rectangle"
echo " - Vimac (or other keyboard mouse tools)"

echo "✅ Setup complete!"
