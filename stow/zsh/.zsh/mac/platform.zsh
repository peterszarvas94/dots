eval "$(/opt/homebrew/bin/brew shellenv)"

export HOMEBREW_NO_AUTO_UPDATE=1

path=(${path:#/opt/homebrew/opt/ruby/bin})
path+=("/opt/homebrew/bin")
path=("/opt/homebrew/opt/llvm/bin" $path)

typeset -U path
export PATH

if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh)"
fi
