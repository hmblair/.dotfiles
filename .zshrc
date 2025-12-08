#!/usr/bin/env zsh

# Ensure we stay in emacs mode

bindkey -e

# Init oh-my-posh

if [[ "$TERM_PROGRAM" != "Apple_Terminal" ]] && command -v oh-my-posh &>/dev/null; then
    eval "$(oh-my-posh init zsh --config "$HOME/.config/oh-my-posh/config.toml")"
fi

# Init autocompletions

autoload -Uz compinit
compinit

# Init fzf

if command -v fzf &>/dev/null; then
    source <(fzf --zsh)
    export FZF_DEFAULT_OPTS_FILE="$HOME/.config/fzf/config"
fi

# Init conda and mamba

if command -v conda &> /dev/null; then
    eval "$(conda "shell.$(basename "${SHELL}")" hook)"
fi

# Init zsh plugins

ZSH_PLUGIN_DIR="${LOCAL_PREFIX:-$HOME/.local}/zsh"
[[ -f "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
    source "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -f "$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
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
