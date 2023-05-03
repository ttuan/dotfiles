FZF_TMUX_HEIGHT=20
export FZF_DEFAULT_COMMAND='rg --files --follow --no-ignore-vcs --hidden -g "!{node_modules/*,.git/*}"'
export FZF_COMPLETION_TRIGGER='~'
bindkey '^T' fzf-completion
bindkey '^O' fzf-history-widget

# Open file with Vim
v() {
  local file
  file=$(fzf --query="$1") && nvim "$file"
}

# cd to folder
fcd() {
  local dir
  dir=$(find ${1:-*} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# show all hidden folder to 'cd'
fda() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# Search in history
fh() {
  eval $(history | fzf +s | sed 's/ *[0-9]* *//')
}

# Kill a process
fk() {
  ps -ef | sed 1d | fzf -m | awk '{print $2}' | xargs kill -${1:-9}
}

# Checkout a branch
fbr() {
  local branches branch
  branches=$(git branch) &&
  branch=$(echo "$branches" | fzf +s +m) &&
  git checkout $(echo "$branch" | sed "s/.* //")
}

# fbd - delete git branch (including remote branches)
# https://peterp.me/cli-tips-interactive-branch-delete/
fbd() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" | fzf --multi ) &&
  git branch -D $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# Checkout a commit
fco() {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf +s +m -e) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}

# Search tags
ft() {
  local line
  [ -e tags ] &&
    line=$(grep -v "^!" tags | cut -f1-3 | cut -c1-80 | fzf --nth=1) &&
    $EDITOR $(cut -f2 <<< "$line")
}

# fq1 [QUERY]
# - Immediately select the file when there's only one match.
#   If not, start the fuzzy finder as usual.
fq1() {
  local lines
  lines=$(fzf --filter="$1" --no-sort)
  if [ -z "$lines" ]; then
    return 1
  elif [ $(wc -l <<< "$lines") -eq 1 ]; then
    echo "$lines"
  else
    echo "$lines" | fzf --query="$1"
  fi
}

# fe [QUERY]
# - Open the selected file with the default editor
#   (Bypass fuzzy finder when there's only one match)
fe() {
  local file
  file=$(fq1 "$1") && ${EDITOR:-vim} "$file"
}
