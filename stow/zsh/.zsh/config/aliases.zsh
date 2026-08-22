alias v="nvim"

# gems backend 
alias bcompose="docker compose --project-directory ~/Work/gems-backend-platform -f docker-compose.yml -f docker-compose.local.yml"
alias bdown="bcompose down"
alias bup="bcompose up -d"
alias bdok="bdown && bup"
alias bbuild="npm run build -C ~/Work/gems-backend-platform"
alias bgen="npm run generate:mig -C ~/Work/gems-backend-platform/packages/database"
alias bmig="npm run migrate -C ~/Work/gems-backend-platform/packages/database"
alias binit="npm run init-development -C ~/Work/gems-backend-platform/packages/database"
alias bstart="CONFIG_FILE=./config.local.yaml npm run start -C ~/Work/gems-backend-platform/packages/app"
alias bdev="CONFIG_FILE=./config.local.yaml npm run start:dev -C ~/Work/gems-backend-platform/packages/app"
alias bdebug="CONFIG_FILE=./config.local.yaml npm run start:debug -C ~/Work/gems-backend-platform/packages/app"
alias ball="bbuild && binit && bstart"

# gems frontend
alias fbuild="npm run build -C ~/Work/gems-frontend-platform/packages/app-center"
alias fdev="npm run dev -C ~/Work/gems-frontend-platform/packages/app-center"
alias fpre="npm run preview -C ~/Work/gems-frontend-platform/packages/app-center"
alias genapi="npm run generate:api -C ~/Work/gems-frontend-platform"
alias genobject="npm run generate:object -C ~/Work/gems-frontend-platform"

# misc
alias openfile='nvim "$(find . -type f | fzf)"'
alias ftp="termscp"
alias zed="open -a /Applications/Zed.app -n"

# tmux
alias ta="tmux a"
alias ts="tmux-sessionizer"
alias tk="tmux kill-server"


alias lgit="lazygit"
alias ldocker="lazydocker"

alias conform-log='cat ~/.local/state/nvim/conform.log | less -R'
alias conform-file='nvim ~/.local/state/nvim/conform.log'

uuid() {
  local id
  id="$(uuidgen | tr '[:upper:]' '[:lower:]')"

  if command -v wl-copy >/dev/null 2>&1; then
    printf %s "$id" | wl-copy
  elif command -v pbcopy >/dev/null 2>&1; then
    printf %s "$id" | pbcopy
  elif command -v xclip >/dev/null 2>&1; then
    printf %s "$id" | xclip -selection clipboard
  else
    printf '%s\n' "$id"
    printf 'No clipboard tool found (tried wl-copy, pbcopy, xclip).\n' >&2
    return 1
  fi

  printf '%s\n' "$id"
}

alias config="$HOME/Projects/dots/config"

alias wip="git add . && git commit -m 'wip' --no-verify && git push"
alias amend="git add . && git commit --amend --no-edit && git push"

rebase() {
  local base_branch="${1:-development}"

  git switch "$base_branch" && \
    git pull && \
    git switch - && \
    git rebase "$base_branch"
}

alias fix-droidcam="sudo rmmod v4l2loopback && sudo modprobe v4l2loopback video_nr=0 card_label=\"DroidCam\" exclusive_caps=1 && droidcam"

oc() {
  local directory project_directory reply
  if (( $# == 0 )); then
    opencode attach http://asimov:4096 --dir .
    return
  fi
  if ! directory="$(zoxide query -- "$@")"; then
    directory="$(builtin cd -- "$1" 2>/dev/null && pwd -P)"
  fi
  if [[ -z "$directory" || ! -d "$directory" ]]; then
    project_directory="$HOME/Projects/${1:t}"
    read -q "reply?Directory '$directory' not found. Create '$project_directory'? [y/N] "
    print
    [[ "$reply" == [yY] ]] || return 1
    mkdir -p "$project_directory" || return 1
    directory="$project_directory"
  fi
  opencode attach http://asimov:4096 --dir "$directory"
}
if [[ "$OSTYPE" != darwin* ]]; then
  alias open="xdg-open"
fi
