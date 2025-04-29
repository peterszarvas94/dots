# nvim default dark mode
export FZF_DEFAULT_OPTS="--color=fg+:#e0e2ea,info:#ffc0b9,spinner:#a6dbff,bg+:#4F5258,pointer:#fce094,hl:#fce094,bg:#14161b,fg:#e0e2ea,prompt:#b4f6c0,marker:#fce094,header:#a6dbff,hl+:#fce094"

# nvim default light mode
# export FZF_DEFAULT_OPTS="--color=fg+:#14161b,info:#640009,spinner:#005574,bg+:#9b9ea4,pointer:#765d00,hl:#765d00,bg:#e0e2ea,fg:#14161b,prompt:#006029,marker:#765d00,header:#005574,hl+:#765d00"

zstyle ':fzf-tab:*' fzf-flags $(echo $FZF_DEFAULT_OPTS)
