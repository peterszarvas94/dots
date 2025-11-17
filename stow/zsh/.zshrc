source ~/.zsh/config/env.public.zsh
source ~/.zsh/config/env.zsh
source ~/.zsh/config/docker.zsh

autoload -Uz compinit
# compinit -i
compinit

source ~/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/config/cursor.zsh
source ~/.zsh/config/keybinds.zsh
source ~/.zsh/config/aliases.zsh
source ~/.zsh/config/prompt-style.zsh
source ~/.zsh/config/fzf-theme.zsh
source ~/.zsh/config/ssh.zsh

alias config="$HOME/projects/dots/config"

# bun completions
[ -s "/Users/szarvaspeter/.bun/_bun" ] && source "/Users/szarvaspeter/.bun/_bun"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
