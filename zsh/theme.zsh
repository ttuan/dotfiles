# ZSH_THEME="agnoster"
#
# prompt_dir() {
#   shorten_path=$(echo $PWD | perl -pe "s/(\w)[^\/]+\//\1\//g")
#   prompt_segment blue $CURRENT_FG $shorten_path
# }

# ============================================================================
# ZSH_THEME="af-magic"
prompt_dir() {
  echo "$PWD" | sed "s|^$HOME|~|" | perl -pe "s/(\w)[^\/]+\//\1\//g"
}

prompt_git() {
  (( $+commands[git] )) || return
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]]; then
    return
  fi

  local PL_BRANCH_CHAR
  () {
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    PL_BRANCH_CHAR=$'\ue0a0'         # 
  }

  local ref dirty mode repo_path

  if [[ "$(command git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]]; then
    repo_path=$(command git rev-parse --git-dir 2>/dev/null)
    dirty=$(parse_git_dirty)
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
      ref="◈ $(command git describe --exact-match --tags HEAD 2> /dev/null)" || \
      ref="➦ $(command git rev-parse --short HEAD 2> /dev/null)"

    # Change text color based on dirty status
    if [[ -n $dirty ]]; then
      echo -n "%F{yellow}"
    else
      echo -n "%F{green}"
    fi

    local ahead behind
    ahead=$(command git log --oneline @{upstream}.. 2>/dev/null)
    behind=$(command git log --oneline ..@{upstream} 2>/dev/null)
    if [[ -n "$ahead" ]] && [[ -n "$behind" ]]; then
      PL_BRANCH_CHAR=$'\u21c5'
    elif [[ -n "$ahead" ]]; then
      PL_BRANCH_CHAR=$'\u21b1'
    elif [[ -n "$behind" ]]; then
      PL_BRANCH_CHAR=$'\u21b0'
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    # Remove background color segment but preserve text color
    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:*' unstagedstr '±'
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats ' %u%c'
    vcs_info

    # Output the ref, branch, and mode information
    echo -n " ${${ref:gs/%/%%}/refs\/heads\//$PL_BRANCH_CHAR }${vcs_info_msg_0_%% }${mode}%f"
  fi
}

export PS1="${FG[237]}\${(l.\$(afmagic_dashes)..-.)}%{$reset_color%}
${FG[032]}\$(prompt_dir)\$(prompt_git)\$(hg_prompt_info) ${FG[105]}%(!.#.»)%{$reset_color%} "
