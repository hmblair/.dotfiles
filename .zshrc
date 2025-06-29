#!/bin/zsh

source ~/.config/zsh/funcs

# Init oh-my-posh

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
    eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/config.toml)"
fi

# Autocomplete ssh paths; do not complete URLs

autoload -Uz compinit
compinit
zstyle ':completion:*:*:argument*' tag-order - '! urls'

# Advanced autocomplete settings

HISTFILE=~/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward
