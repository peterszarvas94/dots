function vcs_branch_name() {
  local name state

  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    name=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    [[ -z $name ]] && return

    if [[ -n $(git diff --name-only --diff-filter=U 2>/dev/null) ]]; then
      state="!"
    elif [[ -n $(git status --porcelain 2>/dev/null) ]]; then
      state="*"
    else
      state=""
    fi

    echo "%F{yellow}${name}${state}%f"
  fi
}

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

PROMPT='%F{green}%n@%m%f $(prompt_path_name) $(vcs_branch_name)
%F{red}$%f '
