function vcs_branch_name() {
  local name dirty

  if command -v jj >/dev/null 2>&1 && jj root --ignore-working-copy >/dev/null 2>&1; then
    name=$(jj log -r @ --no-graph -T 'bookmarks' 2>/dev/null)
    if [[ -z $name ]]; then
      name=$(jj log -r @ --no-graph -T 'change_id.short()' 2>/dev/null)
    fi

    [[ -n $(jj diff --summary 2>/dev/null) ]] && dirty="*"
    echo "%F{yellow}jj:${name}${dirty}%f"
    return
  fi

  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    name=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    [[ -z $name ]] && return

    [[ -n $(git status --porcelain 2>/dev/null) ]] && dirty="*"
    echo "%F{yellow}git:${name}${dirty}%f"
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
%F{green}>%f '
