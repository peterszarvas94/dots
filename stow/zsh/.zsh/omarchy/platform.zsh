eval "$(try init ~/src/tries)"

export NVM_DIR="$HOME/.nvm"

# Arch's nvm package installs the shared script outside NVM_DIR.
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
elif [[ -s /usr/share/nvm/nvm.sh ]]; then
  source /usr/share/nvm/nvm.sh
fi

if [[ -s "$NVM_DIR/bash_completion" ]]; then
  source "$NVM_DIR/bash_completion"
elif [[ -s /usr/share/nvm/bash_completion ]]; then
  source /usr/share/nvm/bash_completion
fi
