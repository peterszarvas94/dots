function vcs_branch_name() {
  local name dirty

  if command -v jj >/dev/null 2>&1 && jj root --ignore-working-copy >/dev/null 2>&1; then
    name=$(jj log -r @ --no-graph -T 'bookmarks' 2>/dev/null)
    if [[ -z $name ]]; then
      name=$(jj log -r @ --no-graph -T 'change_id.short()' 2>/dev/null)
    fi

    [[ -n $(jj diff --summary 2>/dev/null) ]] && dirty="*"
    echo "(jj:${name}${dirty})"
    return
  fi

  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    name=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    [[ -z $name ]] && return

    [[ -n $(git status --porcelain 2>/dev/null) ]] && dirty="*"
    echo "(git:${name}${dirty})"
  fi
}

# cattpuccin
setopt PROMPT_SUBST
PROMPT='%F{white}%~%b%f %F{yellow}$(vcs_branch_name)%f
'
