#!/bin/zsh

# Init oh-my-posh

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
    eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/config.toml)"
fi

# Init fzf

source <(fzf --zsh)
export FZF_DEFAULT_OPTS_FILE="$HOME/.config/fzf/config"

# Init miniconda

if command -v conda &> /dev/null; then
    eval "$(conda "shell.$(basename "${SHELL}")" hook)"
fi

# Import aliases

source ~/.config/shell/aliases

# Init syntax highlighting

if [[ "$OSTYPE" == "darwin"* ]]; then
  source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Init autosuggestions

source ~/.config/zsh/autosuggestions/zsh-autosuggestions.zsh
export ZSH_AUTOSUGGEST_STRATEGY=(completion)
setopt menu_complete

# Advanced history settings

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

# Misc options

setopt cd_silent
