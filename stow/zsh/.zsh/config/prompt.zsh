function vcs_branch_name() {
  local name state vcs_status

  if command -v jj >/dev/null 2>&1 && jj root --ignore-working-copy >/dev/null 2>&1; then
    name=$(jj log -r @ --no-graph -T 'bookmarks' 2>/dev/null)
    if [[ -z $name ]]; then
      name=$(jj log -r @ --no-graph -T 'change_id.short()' 2>/dev/null)
    fi
    name=${name//\*/}

    vcs_status=$(jj status 2>/dev/null)
    if [[ $vcs_status == *conflict* ]]; then
      state="conflict"
    elif [[ -n $(jj diff --summary 2>/dev/null) ]]; then
      state="changed"
    else
      state="empty"
    fi

    echo "%F{yellow}jj:${name}%f %F{red}${state}%f"
    return
  fi

  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    name=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    [[ -z $name ]] && return

    if [[ -n $(git diff --name-only --diff-filter=U 2>/dev/null) ]]; then
      state="conflict"
    elif [[ -n $(git status --porcelain 2>/dev/null) ]]; then
      state="changed"
    else
      state="clean"
    fi

    echo "%F{yellow}git:${name}%f %F{red}${state}%f"
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

PROMPT='$(prompt_path_name) $(vcs_branch_name)
%F{reset}$%f '
