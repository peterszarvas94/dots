# Minimal zsh config for headless Linux servers.

autoload -Uz compinit
compinit -C

source ~/.zsh/config/prompt.zsh

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-nvim}"
export TERM="${TERM:-xterm-256color}"
export COLORTERM="${COLORTERM:-truecolor}"

path=("$HOME/.local/bin" $path)

setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

# TR-100 machine report (previously triggered from ~/.bashrc)
if [[ -o interactive ]] && [[ -x "$HOME/.machine_report.sh" ]]; then
  "$HOME/.machine_report.sh"
fi
