#!/bin/zsh

# Import aliases

source ~/.config/shell/aliases

# Init oh-my-posh

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
    eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/config.toml)"
fi

# Init miniconda

if command -v conda &> /dev/null; then
    eval "$(conda "shell.$(basename "${SHELL}")" hook)"
fi

# Syntax highlighting

if [[ "$OSTYPE" == "darwin"* ]]; then
  source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Advanced autocomplete settings

HISTFILE=~/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt hist_expire_dups_first
setopt hist_ignore_dups

bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# Autocomplete ssh paths; do not complete URLs

autoload -Uz compinit
compinit
zstyle ':completion:*:*:argument*' tag-order - '! urls'
