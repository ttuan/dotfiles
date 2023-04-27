export ALFRED_MY_MIND=~/Dropbox/Projects/alfred-my-mind/workflow/

# Speed up zsh startup - https://gist.github.com/ctechols/ca1035271ad134841284#gistcomment-2308206
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# ============ Mac Only ===============
# Refresh AlfredMyMind - MacOS only
refresh() {
  cd $ALFRED_MY_MIND
  ./update.sh
}

# ============ Git ===============
# Checkout a pullrequest
gcp() {
  git fetch upstream pull/$1/head:pullrequest/$1 --force
  git checkout pullrequest/$1
}

# Delete multiple branch with parttern
gdb() {
  git branch | grep $1 | xargs git branch -D
}

# Delete current branch, local and remote.
# Ref: https://github.com/thoughtbot/guides/tree/master/protocol/git
d.() {
  curr_branch=$(git symbolic-ref --short -q HEAD);
  git checkout develop;
  git br -D $curr_branch;
  # git push origin --delete $curr_branch
}

# Pull code from upstream and run migrate if new migration files is detected.
gpu() {
  curr_branch=$(git symbolic-ref --short -q HEAD);
  git pull upstream $curr_branch;
  # run_migrate;
}

# Commit all changes, push to remote and open new tab in Google Chrome.
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
  repo_name=(${=repo_url//:/ })    # Zsh split string to arr T.T
  rn=(${=repo_name[2]//./ })
  github_url="https://github.com/${rn[1]}/pull/new/$branch_name"
  if [ "$(uname)" '==' "Darwin" ]; then
    open -a "Google Chrome" $github_url
  elif [ "$(expr substr $(uname -s) 1 5)" '==' "Linux" ]; then
    google-chrome $github_url
  elif [ "$(expr substr $(uname -s) 1 10)" '==' "MINGW32_NT" ]; then
      # Do something under Windows NT platform
  fi
}

# Force push changes.
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

# Rebase process
grb() {
  curr_branch=$(git symbolic-ref --short -q HEAD);
  git checkout $1;
  git pull upstream $1;
  git checkout $curr_branch;
  git rebase $1;
}

# Force push after fixing conflict from rebasing process
grc() {
  git add .;
  git rebase --continue;
  branch_name=$(git symbolic-ref --short -q HEAD);
  git push origin $branch_name -f;
}

# Checkout new branch
gcc() {
  git checkout master;
  git checkout -b $1;
}

# Simple commit :D
gcm() {
  git add .;
  git commit -m $1;
  # branch_name=$(git symbolic-ref --short -q HEAD);
  # git push origin $branch_name;
}

# Git fetch upstream branch
gfetch() {
  git fetch upstream $1:$1
  git checkout $1
}

# ============ Development ===============
# Detect new migration files and run migrate
run_migrate() {
  if rake db:migrate:status | grep down
  then
    rake db:migrate
    return 0;
  fi
}

# Recheck before upload code to github
recheck() {
  bundle audit
  bundle exec rubocop --require rubocop/formatter/checkstyle_formatter  --rails app/ lib/
  bundle exec rspec --exclude-pattern "spec/{integration}/**/*_spec.rb"
  bundle exec brakeman
  bundle exec rails_best_practices .
  bundle exec reek app/ lib/
}

# Run Ruby code from clipboard content
rcc() {
  file_name=`cat /dev/urandom | tr -cd 'a-f0-9' | head -c 32`
  clippaste > "/tmp/$file_name.rb"
  ruby "/tmp/$file_name.rb"
}

# Go to a line in file on Github page
goGithubLine() {
  file_name=$1
  line=$2
  repo_url=$(git config --get remote.upstream.url)
  repo_name=(${=repo_url//:/ })
  rn=(${=repo_name[2]//./ })
  google-chrome "https://github.com/${rn[1]}/blob/develop/${file_name}#L${line}"
}

# GRV - git project viewer
gv() {
  ~/grv -repoFilePath ~/Dropbox/Projects/$1
}

# ============ System ===============
mkcd() {
  mkdir "$1"
  cd "$1"
}

search() { find . -iname "*$@*" | less; }

# Copy file content to clipboard
ctc() {
  if [ "$(uname 2> /dev/null)" != "Linux" ]; then
    pbcopy < $1
  else
    cat $1 | xclip -i
  fi
}

# Weather
weather() {
  local CITY=${1:-Hanoi}
  curl -4 "wttr.in/$CITY"
}
