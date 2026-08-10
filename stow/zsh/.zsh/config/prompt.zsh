function prompt_path_name() {
  local path_name prefix last

  path_name=${PWD/#$HOME/\~}
  if [[ $path_name == */* ]]; then
    prefix=${path_name%/*}/
    last=${path_name##*/}
    echo "${prefix}${last}"
  else
    echo "${path_name}"
  fi
}

# cattpuccin
setopt PROMPT_SUBST

autoload -Uz add-zsh-hook

prompt_blank_line() {
  if [[ -n "$PROMPT_ALREADY_SHOWN" ]]; then
    print
  fi
  PROMPT_ALREADY_SHOWN=1
}

add-zsh-hook precmd prompt_blank_line

PROMPT='%F{green}%n@%m%f $(prompt_path_name)
%F{red}$%f '
