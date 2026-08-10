export HOMEBREW_NO_AUTO_UPDATE=1

if command -v brew >/dev/null 2>&1; then
  eval "$(brew shellenv)"

  brew_prefix="$(brew --prefix)"
  path+=("$brew_prefix/bin")

  ruby_prefix="$(brew --prefix ruby 2>/dev/null || true)"
  [[ -n "$ruby_prefix" ]] && path=(${path:#$ruby_prefix/bin})

  llvm_prefix="$(brew --prefix llvm 2>/dev/null || true)"
  [[ -n "$llvm_prefix" ]] && path=("$llvm_prefix/bin" $path)
fi

export NVM_DIR="$HOME/.nvm"

# Homebrew uses /opt/homebrew on Apple Silicon and /usr/local on Intel.
if command -v brew >/dev/null 2>&1; then
  nvm_prefix="$(brew --prefix nvm 2>/dev/null || true)"
  if [[ -n "$nvm_prefix" && -s "$nvm_prefix/nvm.sh" ]]; then
    source "$nvm_prefix/nvm.sh"
    [[ -s "$nvm_prefix/etc/bash_completion.d/nvm" ]] && source "$nvm_prefix/etc/bash_completion.d/nvm"
  fi
fi
