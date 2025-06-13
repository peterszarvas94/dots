# nvim default dark mode
# export FZF_DEFAULT_OPTS="--color=fg+:#e0e2ea,info:#ffc0b9,spinner:#a6dbff,bg+:#4F5258,pointer:#fce094,hl:#fce094,fg:#e0e2ea,prompt:#b4f6c0,marker:#fce094,header:#a6dbff,hl+:#fce094"
# bg:#14161b,

# nvim default light mode
# export FZF_DEFAULT_OPTS="--color=fg+:#14161b,info:#640009,spinner:#005574,bg+:#9b9ea4,pointer:#765d00,hl:#765d00,fg:#14161b,prompt:#006029,marker:#765d00,header:#005574,hl+:#765d00"
# bg:#e0e2ea,

# cattpuccin mocha darker bg
export FZF_DEFAULT_OPTS="--color=fg+:#cdd6f4,info:#f38ba8,spinner:#89b4fa,bg+:#45475a,pointer:#f9e2af,hl:#f9e2af,fg:#cdd6f4,prompt:#a6e3a1,marker:#f9e2af,header:#89b4fa,hl+:#f9e2af"

zstyle ':fzf-tab:*' fzf-flags $(echo $FZF_DEFAULT_OPTS)
