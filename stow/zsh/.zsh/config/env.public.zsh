export NODE_OPTIONS="--max-old-space-size=4096"
export EDITOR='nvim'
export VISUAL='nvim'
export TERM='xterm-256color'
export COLORTERM='truecolor'

if [ "$(uname)" = "Darwin" ]; then
    alias brave='/Applications/Brave\ Browser.app/Contents/MacOS/Brave\ Browser'
    export BROWSER="open"
elif [ "$(uname)" = "Linux" ]; then
    export BROWSER="xdg-open"
fi

# scripts
export PATH="$HOME/.local/bin:$HOME/.local/share/nvim/mason/bin:$PATH"

# go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# brew
export PATH=$PATH:/opt/homebrew/bin

# bun
# [ -s "/Users/szarvaspeter/.bun/_bun" ] && source "/Users/szarvaspeter/.bun/_bun"
# export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
# export PATH="/home/peti/.cache/.bun/bin:$PATH"

# bun
[ -s "/Users/szarvaspeter/.bun/_bun" ] && source "/Users/szarvaspeter/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# turso
export PATH="~/.turso:$PATH"

# zdg
export XDG_CONFIG_HOME="$HOME/.config"

# ruby
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export GEM_HOME="$HOME/.gem"
export GEM_PATH="$GEM_HOME"
export PATH="$GEM_HOME/bin:$PATH"

export PATH="$HOME/.nodev/current:$PATH"

export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export HOMEBREW_NO_AUTO_UPDATE=1

export PATH="/Users/szarvaspeter/.deno/bin:$PATH"
