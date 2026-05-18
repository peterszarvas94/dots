source ~/.zsh/config/env.public.zsh
source ~/.zsh/config/env.zsh
source ~/.zsh/config/docker.zsh
source ~/.zsh/config/platform.zsh

autoload -Uz compinit
# compinit -i
compinit

source ~/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source <(docker completion zsh)
source <(colima completion zsh)

source ~/.zsh/config/keybinds.zsh
source ~/.zsh/config/aliases.zsh
source ~/.zsh/config/prompt.zsh
source ~/.zsh/config/ssh.zsh
source ~/.zsh/config/history.zsh
source ~/.zsh/config/zoxide.zsh

if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh)"
fi


if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi
