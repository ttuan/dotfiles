DOTFILE=~/Dropbox/Projects/dotfile
export TODO_DIR=~/Dropbox/App/todo

# Alias for Git
alias gd="git diff @~..@"
alias grs="git reset HEAD~1"
alias gst="git status -s"
alias gsta="git add -A; git stash"
alias gcl="git clone $(xclip -selection c -o)"    # Xclip required

# Alias for todo.txt
alias t='todo.sh'

# Sort output by priority and number
export TODOTXT_SORT_COMMAND='env LC_COLLATE=C sort -k 2,2 -k 1,1n'

run_migrate() {
  if rake db:migrate:status | grep down
  then
    rake db:migrate
    return 0;
  fi
}

d.() {
  curr_branch=$(git symbolic-ref --short -q HEAD);
  git checkout develop;
  git br -D $curr_branch;
}

gpf() {
  git pull framgia develop;
  run_migrate;
}

gf() {
  git add -A;
  git commit -m $1;
  branch_name=$(git symbolic-ref --short -q HEAD);
  if gd | grep "binding.pry"
  then
    echo "Binding pry detected!"
    return 0
  fi
  git push origin $branch_name;
  repo_url=$(git config --get remote.origin.url)
  if [ "$(uname)" == "Darwin" ]; then
    open -a /Applications/Firefox.app -g $repo_url
  elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    firefox ($repo_url | tr ":" "/");
  elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
      # Do something under Windows NT platform
  fi
}

gff() {
  git add -A;
  git commit --amend;
  branch_name=$(git symbolic-ref --short -q HEAD);
  if gd | grep "binding.pry"
  then
    echo "Binding pry detected!"
    return 0
  fi
  git push origin $branch_name -f;
}

grb() {
  curr_branch=$(git symbolic-ref --short -q HEAD);
  git checkout $1;
  git pull framgia $1;
  git checkout $curr_branch;
  git rebase $1;
}

grc() {
  git add .;
  git rebase --continue;
  branch_name=$(git symbolic-ref --short -q HEAD);
  git push origin $branch_name -f;
}

gcc() {
  git checkout master;
  git checkout -b $1;
}

gcm() {
  git add .;
  git commit -m $1;
  branch_name=$(git symbolic-ref --short -q HEAD);
  git push origin $branch_name;
}

#\\ System
alias sdown="sudo shutdown -h now"
alias gno="gnome-open"
alias bi="bundle install"
alias tmx="tmuxinator start project $1"
alias serve="python -m SimpleHTTPServer 8000"

alias pls="sudo"
alias rr="rm -rf"
alias q="exit"
alias c="clear"
alias ss="source ~/.zshrc; echo 'Source zshrc complete';"

alias h="history | grep"
alias ps="ps aux | grep"

alias kill="sudo killall -9"

# ls
alias ll="ls -lah"
alias la="ls -A"
alias l="ls"

# Connect wifi
alias onwifi="nmcli nm wifi on"
alias offwifi="nmcli nm wifi off"
alias showwifi="nmcli device wifi list"
alias rescanwifi="nmcli device wifi rescan"
cnwifi() {
  nmcli device wifi connect $1 password $2
}

# File system tree
alias .='pwd'
alias ..='cd ..'
alias ...='cd ../..'

alias dot="cd $DOTFILE"

mkcd() {
  mkdir "$1"
  cd "$1"
}
search() { find . -iname "*$@*" | less; }

#\\ Application
alias update="sudo apt-get update"
alias install="sudo apt-get install"
alias add="sudo add-apt-repository"

# Extend
# Weather
weather() {
  local CITY=${1:-Hanoi}
  curl -4 "wttr.in/$CITY"
}

# Translate with google
# alias t="trans -b :vi"

# How do I ....
alias how="howdoi"

#\\ Share wifi
alias sspot="sudo ap-hotspot start"
alias espot="sudo ap-hotspot stop"
alias cspot="sudo ap-hotspot configure"
alias rspot="sudo ap-hotspot restart"


# only for Mac
alias stopsql="launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist"
alias startsql="launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist"
