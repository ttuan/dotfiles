# ZSH_THEME="agnoster"
#
# prompt_dir() {
#   shorten_path=$(echo $PWD | perl -pe "s/(\w)[^\/]+\//\1\//g")
#   prompt_segment blue $CURRENT_FG $shorten_path
# }

# af-magic theme
prompt_dir() {
  echo "$PWD" | sed "s|^$HOME|~|" | perl -pe "s/(\w)[^\/]+\//\1\//g"
}

export PS1="${FG[237]}\${(l.\$(afmagic_dashes)..-.)}%{$reset_color%}
${FG[032]}\$(prompt_dir)\$(git_prompt_info)\$(hg_prompt_info) ${FG[105]}%(!.#.»)%{$reset_color%} "
