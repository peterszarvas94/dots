# options
export NODE_OPTIONS="--max-old-space-size=4096"
export EDITOR='nvim'
export VISUAL='nvim'
export TERM='xterm-256color'
export COLORTERM='truecolor'

# avoid stale RubyGems overrides from parent shells
unset GEM_HOME GEM_PATH
path=(${path:#$HOME/.gem/bin})

# scripts
path=("$HOME/.local/bin" "$HOME/.local/share/nvim/mason/bin" $path)

# go
export GOPATH="$HOME/go"
path=("$GOPATH/bin" $path)

# bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
path=("$BUN_INSTALL/bin" $path)

# turso
path=("$HOME/.turso" $path)

# zdg
export XDG_CONFIG_HOME="$HOME/.config"

# deno
path=("$HOME/.deno/bin" $path)

# fzf
export FZF_DEFAULT_OPTS="--no-color"
zstyle ':fzf-tab:*' fzf-flags $(echo $FZF_DEFAULT_OPTS)

# history
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

# ssh
export SSH_AUTH_SOCK=~/.1password/agent.sock

# path
typeset -U path
export PATH
