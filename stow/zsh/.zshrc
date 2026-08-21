# path
typeset -U path

# Import the system-wide login environment for interactive zsh sessions.
if [[ -r /etc/environment ]]; then
  setopt allexport
  source /etc/environment
  unsetopt allexport
fi

source ~/.zsh/config/platform.zsh

if [[ "${ZSH_PLATFORM:-}" == server ]]; then
  source ~/.zsh/server/rc.zsh
  return
fi

autoload -Uz compinit
compinit -C

source ~/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

source ~/.zsh/config/keybinds.zsh
source ~/.zsh/config/aliases.zsh

source ~/.zsh/config/prompt.zsh

source <(docker completion zsh)
source <(colima completion zsh)

eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"

export NODE_OPTIONS="--max-old-space-size=4096"
export EDITOR='nvim'
export VISUAL='nvim'
export TERM='xterm-256color'
export COLORTERM='truecolor'

unset GEM_HOME GEM_PATH
path=(${path:#$HOME/.gem/bin})

export GOPATH="$HOME/go"

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"

export XDG_CONFIG_HOME="$HOME/.config"

for dir in \
  "$HOME/.local/share/dots/bin" \
  "$HOME/.local/bin" \
  "$HOME/.local/share/nvim/mason/bin" \
  "$GOPATH/bin" \
  "$BUN_INSTALL/bin" \
  "$HOME/.deno/bin" \
  "$HOME/.cargo/bin" \
  "$HOME/.opencode/bin"
do
  [[ -d "$dir" ]] && path=("$dir" "${path[@]}")
done

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
