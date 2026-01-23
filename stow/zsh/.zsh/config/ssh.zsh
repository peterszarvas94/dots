# if [[ -o interactive ]]; then
#     eval "$(ssh-agent -s)" > /dev/null
#     ssh-add ~/.ssh/github > /dev/null 2>&1
#     ssh-add ~/.ssh/digitalocean > /dev/null 2>&1
#     ssh-add ~/.ssh/linode > /dev/null 2>&1
#     ssh-add ~/.ssh/hetzner > /dev/null 2>&1
# fi

export SSH_AUTH_SOCK=~/.1password/agent.sock
