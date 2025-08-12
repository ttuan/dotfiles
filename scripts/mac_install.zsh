#!/usr/bin/env zsh

# =============================================================================
# macOS Development Environment Installation Script
# =============================================================================
# Description: Automated setup script for macOS development environment
# Author: Your Name
# Version: 2.0
# Updated: $(date +%Y-%m-%d)
# =============================================================================

# =============================================================================
# CONFIGURATION VARIABLES
# =============================================================================

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_FILE="${SCRIPT_DIR}/mac_install.log"
readonly HOMEBREW_PREFIX="/opt/homebrew"
readonly RUBY_VERSION="3.4.5"
readonly RAILS_VERSION="7.2.4"

# =============================================================================
# LOGGING FUNCTIONS
# =============================================================================

setup_logging() {
  touch "$LOG_FILE"
  exec 1> >(tee -a "$LOG_FILE")
  exec 2> >(tee -a "$LOG_FILE" >&2)
  log_info "Installation started at $(date)"
}

log_info() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] [INFO] $1"
}

log_success() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] [SUCCESS] $1"
}

log_warning() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] [WARNING] $1"
}

log_error() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] [ERROR] $1" >&2
}

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================

check_command() {
  if command -v "$1" >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

execute_with_retry() {
  local cmd="$1"
  local max_attempts="${2:-3}"
  local attempt=1

  while [ $attempt -le $max_attempts ]; do
    log_info "Executing (attempt $attempt/$max_attempts): $cmd"
    if eval "$cmd"; then
      return 0
    else
      log_warning "Command failed on attempt $attempt"
      ((attempt++))
      sleep 2
    fi
  done

  log_error "Command failed after $max_attempts attempts: $cmd"
  return 1
}

prompt_continue() {
  local message="$1"
  echo "$message (y/N): "
  read -r response
  case "$response" in
    [yY][eS]|[yY]) return 0 ;;
    *) return 1 ;;
  esac
}

# =============================================================================
# HOMEBREW INSTALLATION
# =============================================================================

install_homebrew() {
  log_info "Starting Homebrew installation"

  if check_command "brew"; then
    log_info "Homebrew already installed, updating..."
    brew update && brew upgrade
    log_success "Homebrew updated successfully"
    return 0
  fi

  log_info "Installing Homebrew..."
  if execute_with_retry '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install)"'; then

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ -f "${HOMEBREW_PREFIX}/bin/brew" ]]; then
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    log_success "Homebrew installed successfully"
  else
    log_error "Failed to install Homebrew"
    return 1
  fi
}

# =============================================================================
# TERMINAL AND SHELL SETUP
# =============================================================================

install_terminal_tools() {
  log_info "Starting terminal tools installation"

  # Install Zsh (usually pre-installed on macOS)
  if ! check_command "zsh"; then
    log_info "Installing Zsh..."
    execute_with_retry "brew install zsh"
  fi

  # Install Oh My Zsh
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    log_info "Installing Oh My Zsh..."
    execute_with_retry 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
  else
    log_info "Oh My Zsh already installed"
  fi

  # Set up custom plugins directory
  local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  # Install Zsh plugins
  log_info "Installing Zsh plugins..."

  if [[ ! -d "$zsh_custom/plugins/zsh-autosuggestions" ]]; then
    execute_with_retry "git clone https://github.com/zsh-users/zsh-autosuggestions $zsh_custom/plugins/zsh-autosuggestions"
  fi

  if [[ ! -d "$zsh_custom/plugins/zsh-syntax-highlighting" ]]; then
    execute_with_retry "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $zsh_custom/plugins/zsh-syntax-highlighting"
  fi

  # Install additional terminal tools
  log_info "Installing terminal utilities..."
  execute_with_retry "brew install fzf"

  # Install fzf shell extensions
  if [[ -f "/opt/homebrew/opt/fzf/install" ]]; then
    execute_with_retry "/opt/homebrew/opt/fzf/install --all"
  elif [[ -f "/usr/local/opt/fzf/install" ]]; then
    execute_with_retry "/usr/local/opt/fzf/install --all"
  fi

  # Install iTerm2
  log_info "Installing iTerm2..."
  execute_with_retry "brew install --cask iterm2"

  log_success "Terminal tools installation completed"
}

# =============================================================================
# SYSTEM CUSTOMIZATION
# =============================================================================

apply_system_customizations() {
  log_info "Applying system customizations"

  # Install Powerline fonts
  local fonts_dir="$HOME/powerline-fonts"
  if [[ ! -d "$fonts_dir" ]]; then
    log_info "Installing Powerline fonts..."
    execute_with_retry "git clone https://github.com/powerline/fonts.git $fonts_dir"
    (cd "$fonts_dir" && ./install.sh)
    log_success "Powerline fonts installed"
  else
    log_info "Powerline fonts already installed"
  fi

  # System preferences
  log_info "Applying system preferences..."

  # Turn off startup sound
  if prompt_continue "Turn off startup sound?"; then
    sudo nvram SystemAudioVolume=" "
    log_success "Startup sound disabled"
  fi

  # Additional system tweaks can be added here
  log_success "System customizations applied"
}

# =============================================================================
# DEVELOPMENT TOOLS
# =============================================================================

install_development_tools() {
  log_info "Installing development tools"

  local dev_tools=(
    "git"
    "the_silver_searcher"
    "tmux"
    "vim"
    "neovim"
    "ripgrep"
    "bat"
    "exa"
    "tree"
    "jq"
    "curl"
    "wget"
  )

  for tool in "${dev_tools[@]}"; do
    log_info "Installing $tool..."
    execute_with_retry "brew install $tool"
  done

  # Install tmux-vim-select-pane (if needed)
  local tmux_script="/usr/local/bin/tmux-vim-select-pane"
  if [[ ! -f "$tmux_script" ]]; then
    log_info "Installing tmux-vim-select-pane..."
    execute_with_retry "curl -fsSL https://raw.github.com/mislav/dotfiles/1500cd2/bin/tmux-vim-select-pane -o $tmux_script"
    chmod +x "$tmux_script"
  fi

  log_success "Development tools installation completed"
}

# =============================================================================
# WEB DEVELOPMENT ENVIRONMENT
# =============================================================================

install_web_development_tools() {
  log_info "Installing web development tools"

  # Install Node.js and npm via Homebrew
  execute_with_retry "brew install node"
  execute_with_retry "brew install yarn"

  # Install Ruby environment
  local ruby_tools=("rbenv" "ruby-build")
  for tool in "${ruby_tools[@]}"; do
    execute_with_retry "brew install $tool"
  done

  # Set up rbenv
  if ! grep -q "rbenv init" ~/.zshrc; then
    log_info "Configuring rbenv in ~/.zshrc..."
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(rbenv init -)"' >> ~/.zshrc
  fi

  # Install Ruby
  if ! rbenv versions | grep -q "$RUBY_VERSION"; then
    log_info "Installing Ruby $RUBY_VERSION..."
    execute_with_retry "rbenv install $RUBY_VERSION"
    execute_with_retry "rbenv global $RUBY_VERSION"

    # Install Rails
    log_info "Installing Rails $RAILS_VERSION..."
    execute_with_retry "gem install rails -v $RAILS_VERSION"
    execute_with_retry "rbenv rehash"
  fi

  # Install additional web dev tools
  local web_tools=("commitizen" "peco")
  for tool in "${web_tools[@]}"; do
    execute_with_retry "brew install $tool"
  done

  # Database installation (optional)
  if prompt_continue "Install MySQL?"; then
    execute_with_retry "brew install mysql"
    execute_with_retry "brew services start mysql"
    log_success "MySQL installed and started"
  fi

  if prompt_continue "Install PostgreSQL?"; then
    execute_with_retry "brew install postgresql"
    execute_with_retry "brew services start postgresql"
    log_success "PostgreSQL installed and started"
  fi

  log_success "Web development tools installation completed"
}

# =============================================================================
# APPLICATION INSTALLATION
# =============================================================================

install_applications() {
  log_info "Installing applications"

  # Development applications
  local dev_apps=(
    "visual-studio-code"
    "sublime-text"
    "docker"
    "postman"
  )

  # Productivity applications
  local productivity_apps=(
    "google-chrome"
    "firefox"
    "dropbox"
    "vlc"
    "rectangle"  # Updated from spectacle
    "alfred"
    "evernote"
    "google-drive"
    "bettertouchtool"
  )

  # Utility applications
  local utility_apps=(
    "macdown"
    "ctags"
  )

  # Install development applications
  if prompt_continue "Install development applications?"; then
    for app in "${dev_apps[@]}"; do
      log_info "Installing $app..."
      execute_with_retry "brew install --cask $app"
    done
  fi

  # Install productivity applications
  if prompt_continue "Install productivity applications?"; then
    for app in "${productivity_apps[@]}"; do
      log_info "Installing $app..."
      execute_with_retry "brew install --cask $app"
    done
  fi

  # Install utility applications
  if prompt_continue "Install utility applications?"; then
    for app in "${utility_apps[@]}"; do
      if [[ "$app" == "ctags" ]]; then
        execute_with_retry "brew install $app"
      else
        execute_with_retry "brew install --cask $app"
      fi
    done
  fi

  log_success "Applications installation completed"
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================

main() {
  echo "==============================================="
  echo "macOS Development Environment Setup"
  echo "==============================================="
  echo

  setup_logging

  log_info "Starting macOS setup process..."

  # Check if running on macOS
  if [[ "$(uname)" != "Darwin" ]]; then
    log_error "This script is designed for macOS only"
    exit 1
  fi

  # Installation steps
  if prompt_continue "Install Homebrew?"; then
    install_homebrew || { log_error "Homebrew installation failed"; exit 1; }
  fi

  if prompt_continue "Install terminal tools?"; then
    install_terminal_tools || { log_error "Terminal tools installation failed"; exit 1; }
  fi

  if prompt_continue "Apply system customizations?"; then
    apply_system_customizations || { log_error "System customizations failed"; exit 1; }
  fi

  if prompt_continue "Install development tools?"; then
    install_development_tools || { log_error "Development tools installation failed"; exit 1; }
  fi

  if prompt_continue "Install web development tools?"; then
    install_web_development_tools || { log_error "Web development tools installation failed"; exit 1; }
  fi

  if prompt_continue "Install applications?"; then
    install_applications || { log_error "Applications installation failed"; exit 1; }
  fi

  log_success "macOS setup completed successfully!"
  log_info "Installation log saved to: $LOG_FILE"

  echo
  echo "==============================================="
  echo "Setup Complete!"
  echo "Please restart your terminal or run:"
  echo "  source ~/.zshrc"
  echo "==============================================="
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
