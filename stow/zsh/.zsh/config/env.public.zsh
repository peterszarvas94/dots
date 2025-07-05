export NODE_OPTIONS="--max-old-space-size=4096"

# scripts
export PATH="$HOME/.local/bin:$HOME/.local/share/nvim/mason/bin:$PATH"

# go
export PATH=$PATH:/usr/local/go/bin
export GOPATH="$HOME/go"
export PATH=$GOPATH/bin:$PATH

# brew
export PATH=$PATH:/opt/homebrew/bin

# environment
# export BROWSER='arc'
export EDITOR='nvim'
export VISUAL='nvim'
export TERM='xterm-256color'

# bun completions
# [ -s "/home/peti/.bun/_bun" ] && source "/home/peti/.bun/_bun"
[ -s "/Userds/szarvaspeter/.bun/_bun" ] && source "/Users/szarvaspeter/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# turso
export PATH="~/.turso:$PATH"

export XDG_CONFIG_HOME="$HOME/.config"
