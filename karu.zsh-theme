function rvm_prompt_info2() {
  ruby_version=$(~/.rvm/bin/rvm-prompt i v g 2> /dev/null) || return
  echo "[$ruby_version]"
}

if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

# primary prompt
PROMPT='$fg[237]%t $FG[032]%~\
$(git_prompt_info) \
$FG[105]%(!.#.»)%{$reset_color%} '
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'
RPS1='${return_code}'

# right prompt
RPROMPT='$FG[237]%n@%m $FG[124]$(rvm_prompt_info2)%{$reset_color%}%'

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX="$FG[075]("
ZSH_THEME_GIT_PROMPT_DIRTY="$FG[166]*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_SUFFIX="$FG[075])%{$reset_color%}"
