#!/usr/bin/env zsh

# Add zu bin to path

export PATH="$HOME/.local/share/zu/bin:$PATH"

# Ensure we stay in emacs mode

bindkey -e

# Init oh-my-posh

if [[ "$TERM_PROGRAM" != "Apple_Terminal" ]]; then
    eval "$(oh-my-posh init zsh --config "$HOME/.config/oh-my-posh/config.toml")"
fi

# Init autocompletions

fpath=(~/.local/share/zu/completions $fpath)
autoload -Uz compinit
compinit

# Init fzf

source <(fzf --zsh)
export FZF_DEFAULT_OPTS_FILE="$HOME/.config/fzf/config"

# Init conda and mamba

if command -v conda &> /dev/null; then
    eval "$(conda "shell.$(basename "${SHELL}")" hook)"
fi

# Init zsh plugins

ZSH_PLUGIN_DIR="$HOME/.config/zsh"
source "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
export ZSH_AUTOSUGGEST_STRATEGY=(completion)
setopt menu_complete

# Advanced history settings

HISTFILE="$HOME/.zhistory"
SAVEHIST=1000
HISTSIZE=999
setopt hist_expire_dups_first
setopt hist_ignore_dups

bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# Autocomplete ssh paths; do not complete URLs

zstyle ':completion:*:*:argument*' tag-order - '! urls'

# zsh options

setopt nullglob
setopt cd_silent
setopt RM_STAR_SILENT

# Import aliases

source "$HOME/.config/shell/aliases"
