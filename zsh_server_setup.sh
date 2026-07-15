#!/usr/bin/env bash

set -euo pipefail

DOTS_DIR="${DOTS_DIR:-$HOME/Projects/dots}"
DOTS_REPO="${DOTS_REPO:-https://github.com/peterszarvas94/dots.git}"
SHIM_DIR="$HOME/.zsh/server/shims"

log() { printf '%s\n' "$*"; }
die() { printf 'error: %s\n' "$*" >&2; exit 1; }

install_packages() {
  if command -v apt-get &>/dev/null; then
    log "Installing packages (apt)..."
    sudo apt-get update
    sudo apt-get install -y zsh git stow fzf
  elif command -v pacman &>/dev/null; then
    log "Installing packages (pacman)..."
    sudo pacman -S --needed --noconfirm zsh git stow fzf
  else
    die "Unsupported package manager. Install zsh, git, stow, and fzf manually."
  fi
}

ensure_dots_repo() {
  if [[ -d "$DOTS_DIR/.git" ]]; then
    log "Updating dots repo at $DOTS_DIR"
    git -C "$DOTS_DIR" pull --ff-only
  else
    log "Cloning dots repo to $DOTS_DIR"
    mkdir -p "$(dirname "$DOTS_DIR")"
    git clone "$DOTS_REPO" "$DOTS_DIR"
  fi
}

write_shim() {
  local name="$1"
  local body="$2"
  local path="$SHIM_DIR/$name"

  cat >"$path" <<EOF
#!/usr/bin/env bash
set -euo pipefail

for dir in \$(printf '%s' "\$PATH" | tr ':' ' '); do
  [[ "\$dir" == *"/server/shims" ]] && continue
  [[ -x "\$dir/$name" ]] && exec "\$dir/$name" "\$@"
done

$body
EOF

  chmod +x "$path"
}

install_shims() {
  log "Installing server shims in $SHIM_DIR"
  mkdir -p "$SHIM_DIR"

  write_shim docker 'case "$1" in
  completion)
    [[ "${2:-}" == zsh ]] && exit 0
    ;;
esac
exit 1'

  write_shim colima 'case "$1" in
  completion)
    [[ "${2:-}" == zsh ]] && exit 0
    ;;
esac
exit 1'

  write_shim mise 'case "$1" in
  activate)
    exit 0
    ;;
esac
exit 1'

  write_shim zoxide 'case "$1" in
  init)
    if [[ "${2:-}" == zsh ]]; then
      cat <<'"'"'SHIM'"'"'
z() { builtin cd "$@"; }
SHIM
    fi
    exit 0
    ;;
esac
exit 1'

  write_shim try 'case "$1" in
  init)
    exit 0
    ;;
esac
exit 1'
}

install_server_env() {
  local env_file="$HOME/.zsh/config/env.zsh"
  local marker="# zsh_server_setup.sh"

  mkdir -p "$HOME/.zsh/config" "$HOME/.vite-plus"
  touch "$HOME/.vite-plus/env"

  if [[ -f "$env_file" ]] && grep -qF "$marker" "$env_file"; then
    log "Server env already configured in $env_file"
    return
  fi

  if [[ -f "$env_file" ]]; then
    log "Appending server shims to existing $env_file"
    cat >>"$env_file" <<EOF

$marker
path=("$SHIM_DIR" \$path)
EOF
  else
    log "Creating $env_file"
    cat >"$env_file" <<EOF
$marker
path=("$SHIM_DIR" \$path)
EOF
  fi
}

deploy_zsh() {
  log "Deploying zsh dotfiles"
  (
    cd "$DOTS_DIR"
    ./config.sh --pkg=zsh
  )
}

set_login_shell() {
  local zsh_path
  zsh_path="$(command -v zsh)" || die "zsh not found after install"

  if [[ "$(getent passwd "$USER" | cut -d: -f7)" == "$zsh_path" ]]; then
    log "Login shell is already $zsh_path"
    return
  fi

  log "Setting login shell to $zsh_path"
  sudo chsh -s "$zsh_path" "$USER"
}

main() {
  install_packages
  ensure_dots_repo
  install_shims
  install_server_env
  deploy_zsh
  set_login_shell

  log ""
  log "Done. Log out and back in, or run: exec zsh"
}

main "$@"
