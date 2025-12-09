#!/usr/bin/env zsh
# Interactive shell configuration

# ─────────────────────────────────────────────────────────────────────────────
# Shell helpers
# ─────────────────────────────────────────────────────────────────────────────

if [[ -f "$HOME/.local/lib/shell/lib.zsh" ]]; then
  source "$HOME/.local/lib/shell/lib.zsh"
else
  # Minimal fallbacks for fresh install
  has_cmd() { command -v "$1" &>/dev/null; }
  safe_source() { [[ -f "$1" ]] && source "$1"; }
  source_dir() { :; }
fi

# ─────────────────────────────────────────────────────────────────────────────
# Keybindings
# ─────────────────────────────────────────────────────────────────────────────

bindkey -e  # Emacs mode
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# ─────────────────────────────────────────────────────────────────────────────
# Prompt (oh-my-posh)
# ─────────────────────────────────────────────────────────────────────────────

if [[ "$TERM_PROGRAM" != "Apple_Terminal" ]] && has_cmd oh-my-posh; then
  local omp_config="$HOME/.config/oh-my-posh/config.toml"
  if [[ -f "$omp_config" ]]; then
    eval "$(oh-my-posh init zsh --config "$omp_config")"
  else
    warn "oh-my-posh config not found: $omp_config"
  fi
fi

# ─────────────────────────────────────────────────────────────────────────────
# Completions
# ─────────────────────────────────────────────────────────────────────────────

autoload -Uz compinit && compinit
zstyle ':completion:*:*:argument*' tag-order - '! urls'
setopt menu_complete

# ─────────────────────────────────────────────────────────────────────────────
# Plugins
# ─────────────────────────────────────────────────────────────────────────────

# fzf
if has_cmd fzf; then
  source <(fzf --zsh)
  local fzf_config="$HOME/.config/fzf/config"
  [[ -f "$fzf_config" ]] && export FZF_DEFAULT_OPTS_FILE="$fzf_config"
fi

# conda
has_cmd conda && eval "$(conda "shell.$(basename "${SHELL}")" hook)"

# zsh plugins
ZSH_PLUGIN_DIR="${LOCAL_PREFIX:-$HOME/.local}/zsh"
safe_source "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
safe_source "$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
export ZSH_AUTOSUGGEST_STRATEGY=(completion)

# ─────────────────────────────────────────────────────────────────────────────
# History
# ─────────────────────────────────────────────────────────────────────────────

HISTFILE="$HOME/.zhistory"
HISTSIZE=999
SAVEHIST=1000
setopt hist_expire_dups_first
setopt hist_ignore_dups

# ─────────────────────────────────────────────────────────────────────────────
# Shell options
# ─────────────────────────────────────────────────────────────────────────────

setopt nullglob
setopt cd_silent
setopt RM_STAR_SILENT

# ─────────────────────────────────────────────────────────────────────────────
# Aliases
# ─────────────────────────────────────────────────────────────────────────────

# Generic aliases (from dotfiles)
safe_source "$HOME/.local/lib/shell/aliases.zsh" --warn

# User-specific aliases (machine-local, not in dotfiles)
source_dir "$HOME/.aliases"
