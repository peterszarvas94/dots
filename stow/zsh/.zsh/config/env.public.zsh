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
alias brave='/Applications/Brave\ Browser.app/Contents/MacOS/Brave\ Browser'
export BROWSER='/Applications/Brave\ Browser.app/Contents/MacOS/Brave\ Browser'
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

# zdg
export XDG_CONFIG_HOME="$HOME/.config"

# ruby
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export GEM_HOME="$HOME/.gem"
export GEM_PATH="$GEM_HOME"
export PATH="$GEM_HOME/bin:$PATH"
