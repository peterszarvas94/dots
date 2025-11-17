export FZF_DEFAULT_OPTS="--no-color"

zstyle ':fzf-tab:*' fzf-flags $(echo $FZF_DEFAULT_OPTS)
