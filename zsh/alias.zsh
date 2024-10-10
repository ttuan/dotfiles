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
alias pn="pnpm"
alias cc="git add . && cz commit"
alias cat=bat

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
export EZA_COLORS="da=38;5;252:sb=38;5;204:sn=38;5;43:xa=8:\
uu=38;5;245:un=38;5;241:ur=38;5;223:uw=38;5;223:ux=38;5;223:ue=38;5;223:\
gr=38;5;153:gw=38;5;153:gx=38;5;153:tr=38;5;175:tw=38;5;175:tx=38;5;175:\
gm=38;5;203:ga=38;5;203:mp=3;38;5;111:im=38;2;180;150;250:vi=38;2;255;190;148:\
mu=38;2;255;175;215:lo=38;2;255;215;183:cr=38;2;240;160;240:\
do=38;2;200;200;246:co=38;2;255;119;153:tm=38;2;148;148;148:\
cm=38;2;230;150;210:bu=38;2;95;215;175:sc=38;2;110;222;222"
alias ll="eza -l -g --icons --sort=.name  --group-directories-first"
alias lla="ll -a"
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

alias vim=nvim
alias rg="rg --colors 'match:bg:yellow' --colors 'match:fg:black' --colors 'match:style:nobold' --colors 'path:fg:green' --colors 'path:style:bold' --colors 'line:fg:yellow' --colors 'line:style:bold'"
