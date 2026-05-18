eval "$(/opt/homebrew/bin/brew shellenv)"

export HOMEBREW_NO_AUTO_UPDATE=1

path=(${path:#/opt/homebrew/opt/ruby/bin})
path+=("/opt/homebrew/bin")
path=("/opt/homebrew/opt/llvm/bin" $path)
