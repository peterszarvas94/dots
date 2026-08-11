# path
typeset -U path

source ~/.zsh/config/env.zsh
source ~/.zsh/config/platform.zsh

if [[ "${ZSH_PLATFORM:-}" == server ]]; then
  source ~/.zsh/server/rc.zsh
  return
fi

autoload -Uz compinit
compinit -C

source ~/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source ~/.zsh/config/keybinds.zsh
source ~/.zsh/config/aliases.zsh

source ~/.zsh/config/prompt.zsh

source "$HOME/.vite-plus/env"
source <(docker completion zsh)
source <(colima completion zsh)

eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"

# opencode
export PATH=/home/peti/.opencode/bin:$PATH

export NODE_OPTIONS="--max-old-space-size=4096"
export EDITOR='nvim'
export VISUAL='nvim'
export TERM='xterm-256color'
export COLORTERM='truecolor'

unset GEM_HOME GEM_PATH
path=(${path:#$HOME/.gem/bin})

path=("$HOME/.local/share/dots/bin" "$HOME/.local/bin" "$HOME/.local/share/nvim/mason/bin" $path)

export GOPATH="$HOME/go"
path=("$GOPATH/bin" $path)

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
path=("$BUN_INSTALL/bin" $path)

export XDG_CONFIG_HOME="$HOME/.config"

path=("$HOME/.deno/bin" $path)

path=("$HOME/.cargo/bin" $path)

# opencode
path=("$HOME/.opencode/bin" $path)

export FZF_DEFAULT_OPTS="--no-color"
zstyle ':fzf-tab:*' fzf-flags $(echo $FZF_DEFAULT_OPTS)

setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

if [[ -z "${SSH_AUTH_SOCK:-}" ]] || ! ssh-add -l &>/dev/null; then
  eval "$(ssh-agent -s)" >/dev/null
fi
ssh-add ~/.ssh/github    2>/dev/null
ssh-add ~/.ssh/minivac_to_asimov 2>/dev/null
ssh-add ~/.ssh/hetzner   2>/dev/null
ssh-add ~/.ssh/linode    2>/dev/null
ssh-add ~/.ssh/bandcash  2>/dev/null
ssh-add ~/.ssh/coolify   2>/dev/null
ssh-add ~/.ssh/scaleway  2>/dev/null

export PATH

# kimi-code
export PATH="/Users/szarvaspeter/.kimi-code/bin:$PATH"
