# Path to Oh My Fish install.
set -gx OMF_PATH /home/whoami/.local/share/omf

# Customize Oh My Fish configuration path.
#set -gx OMF_CONFIG /home/whoami/.config/omf

# Load oh-my-fish configuration.
source $OMF_PATH/init.fish

# Config rvm for ruby on rails
set fish_plugins git rails
rvm default
eval (python -m virtualfish)

# Turn off fish greeting
set fish_greeting ""

set --export EDITOR "vim -f"

# Set Alias
alias lsl "ls -l"
alias bi "bundle install"
alias go "gnome-open"
alias update "sudo apt-get update"
alias install "sudo apt-get install"
alias addrp "sudo add-apt-repository"
alias tmux="tmux -2"

# Config for tmux
set TERM xterm-256color
# set -gx TERM screen-256color-bce;
