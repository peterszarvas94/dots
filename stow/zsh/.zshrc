source_if_exists() {
    local file_path="$1"
    [[ -f "$file_path" ]] && source "$file_path"
}

source_if_exists ~/.zsh/config/env.public.zsh
source_if_exists ~/.zsh/config/env.zsh
source_if_exists ~/.zsh/config/docker.zsh
source_if_exists ~/.zsh/config/platform.zsh

autoload -Uz compinit
# compinit -i
compinit

source_if_exists ~/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
source_if_exists ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source_if_exists ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

if command -v docker >/dev/null 2>&1; then
    source <(docker completion zsh)
fi

if command -v colima >/dev/null 2>&1; then
    source <(colima completion zsh)
fi

source_if_exists ~/.zsh/config/keybinds.zsh
source_if_exists ~/.zsh/config/aliases.zsh
source_if_exists ~/.zsh/config/prompt.zsh
source_if_exists ~/.zsh/config/ssh.zsh
source_if_exists ~/.zsh/config/history.zsh
source_if_exists ~/.zsh/config/zoxide.zsh

if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh)"
fi


if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# opencode
export PATH=/home/peti/.opencode/bin:$PATH

# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"
