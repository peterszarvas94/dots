function git_branch_name() {
  branch=$(git rev-parse --abbrev-ref HEAD)
  if [[ $branch == "" ]]; then
    :
  else
    if [[ -n $(git status --porcelain) ]]; then
      echo "($branch*)"
    else
      echo "($branch)"
    fi
  fi
}

###
# PROMPT 
###

setopt PROMPT_SUBST
PROMPT='%F{yellow}%~%f %F{blue}$(git_branch_name)%f
'
