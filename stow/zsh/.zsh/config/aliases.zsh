# neovim
nvim() {
  local runtime_dir socket
  if [[ -n "${XDG_RUNTIME_DIR:-}" && -d "$XDG_RUNTIME_DIR" ]]; then
    runtime_dir="$XDG_RUNTIME_DIR"
  else
    runtime_dir="/tmp/nvim.${USER}"
    mkdir -p "$runtime_dir"
  fi
  socket="${runtime_dir}/nvim.$$.${RANDOM}.sock"
  command nvim --listen "$socket" "$@"
}

alias v="nvim"

# gems backend 
alias bdown="docker compose --project-directory ~/Work/gems-backend-platform down "
alias bup="docker compose --project-directory ~/Work/gems-backend-platform up -d"
alias bdok="bdown && bup"
alias bbuild="npm run build -C ~/Work/gems-backend-platform"
alias bgen="npm run generate:mig -C ~/Work/gems-backend-platform/packages/database"
alias bmig="npm run migrate -C ~/Work/gems-backend-platform/packages/database"
alias binit="npm run init-development -C ~/Work/gems-backend-platform/packages/database"
alias bstart="npm run start -C ~/Work/gems-backend-platform/packages/app"
alias bdev="npm run start:dev -C ~/Work/gems-backend-platform/packages/app"
alias bdebug="npm run start:debug -C ~/Work/gems-backend-platform/packages/app"
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

alias oc="opencode"
alias open="xdg-open"
