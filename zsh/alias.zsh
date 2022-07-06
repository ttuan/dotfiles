# ============ Git ===============
alias g="git"
alias gd="git diff @~..@"
alias grs="git reset HEAD~1"
# alias gst="git status -s"
alias gsta="git add -A; git stash"
alias gfp="git fetch pullrequest"
# alias gcl="git clone $(xclip -selection c -o)"    # Xclip required

# ============ Devevelopment ===============
alias dc="docker-compose"
alias bi="bundle install"
alias tmx="tmuxinator start project $1"
alias tsd="tmuxinator start django $1"
alias serve="python -m SimpleHTTPServer 8000"

# ============ System ===============
alias ss="source ~/.zshrc; echo 'Source zshrc complete';"
alias pls="sudo"
alias sdown="sudo shutdown -h now"
alias gno="gnome-open"
alias rr="rm -rf"
alias q="exit"
alias c="clear"
alias h="history | grep"
alias ps="ps aux | grep"
alias kill="sudo killall -9"
alias kp="npx kill-port $1"
alias ctags="`brew --prefix`/bin/ctags"

# File system tree
alias .='pwd'
alias ..='cd ..'
alias ...='cd ../..'
alias j='z'

# ls
alias ll="ls -lah"
alias la="ls -A"
alias l="ls"

# APT
alias update="sudo apt-get update"
alias install="sudo apt-get install"
alias add="sudo add-apt-repository"

# How do I ....
alias how="howdoi"

#\\ Share wifi
alias sspot="sudo ap-hotspot start"
alias espot="sudo ap-hotspot stop"
alias cspot="sudo ap-hotspot configure"
alias rspot="sudo ap-hotspot restart"

# Mac only
alias stopsql="launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist"
alias startsql="launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist"
alias off_indexing="sudo mdutil -a -i off"
alias on_indexing="sudo mdutil -a -i on"

# Connect wifi
alias onwifi="nmcli nm wifi on"
alias offwifi="nmcli nm wifi off"
alias showwifi="nmcli device wifi list"
alias rescanwifi="nmcli device wifi rescan"
cnwifi() {
  nmcli device wifi connect $1 password $2
}
