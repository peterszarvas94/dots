function git_branch_name() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ $? -ne 0 ]]; then
      # No branch found (likely an empty repository), return nothing
      return
    fi
    if [[ -z $branch ]]; then
      # No branch is checked out (bare repository or detached HEAD)
      return
    else
      # Branch exists, check if there are changes
      if [[ -n $(git status --porcelain) ]]; then
        echo "($branch*)"
      else
        echo "($branch)"
      fi
    fi
  fi
}

setopt PROMPT_SUBST
PROMPT='%B%F{yellow}%~%b%f %F{blue}$(git_branch_name)%f
'
