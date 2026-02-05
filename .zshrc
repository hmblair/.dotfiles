#!/usr/bin/env zsh
# Interactive shell configuration

# Source .zprofile if not already sourced (e.g., non-login shells like xterm)
[[ -z "$ZPROFILE_SOURCED" ]] && source "$HOME/.zprofile"

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

posh() {
  case "$1" in
    off)
      precmd_functions=(${precmd_functions:#_omp*})
      preexec_functions=(${preexec_functions:#_omp*})
      PROMPT="❯ " RPROMPT=""
      ;;
    on)  eval "$(oh-my-posh init zsh --config "$HOME/.config/oh-my-posh/config.toml")" ;;
    *)   echo "Usage: posh on|off" ;;
  esac
}

if [[ "$TERM_PROGRAM" != "Apple_Terminal" ]] && has_cmd oh-my-posh; then
  posh on
fi

# ─────────────────────────────────────────────────────────────────────────────
# Completions
# ─────────────────────────────────────────────────────────────────────────────

autoload -Uz compinit
if [[ $EUID -eq 0 ]]; then
  compinit -u
else
  compinit
fi
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

  # File lister with icons (matching l script: =dir, =file, =exec, =symlink)
  _fzf_files() {
    fd --type f --type d --type l --hidden --exclude .git 2>/dev/null | while IFS= read -r p; do
      if [[ -L "$p" ]]; then
        printf '\033[36m \033[0m %s\n' "$p"
      elif [[ -d "$p" ]]; then
        printf '\033[34m \033[0m %s\n' "$p"
      elif [[ -x "$p" ]]; then
        printf '\033[32m \033[0m %s\n' "$p"
      else
        printf ' %s\n' "$p"
      fi
    done
  }

  # Default: use fd for speed (colors but no icons)
  has_cmd fd && export FZF_DEFAULT_COMMAND='fd --type f --type d --hidden --exclude .git --color=always'

  # f: fuzzy find files with icons, output clean path
  f() {
    local sel
    sel=$(_fzf_files | fzf --with-nth=2.. --ansi "$@") && printf '%s\n' "${sel#* }"
  }

  # fe: fuzzy find and edit file
  fe() {
    local file
    file=$(f "$@") && ${EDITOR:-vim} "$file"
  }

  # fcd: fuzzy find and cd to directory
  fcd() {
    local dir
    dir=$(fd --type d --hidden --follow --exclude .git --color=always | fzf --ansi "$@") && cd "$dir"
  }
fi

# conda
has_cmd conda && eval "$(conda "shell.$(basename "${SHELL}")" hook)"

# zsh plugins (fzf-tab must be loaded before autosuggestions/syntax-highlighting)
ZSH_PLUGIN_DIR="${LOCAL_PREFIX:-$HOME/.local}/zsh"
[[ -f "$ZSH_PLUGIN_DIR/fzf-tab/fzf-tab.zsh" ]] && source "$ZSH_PLUGIN_DIR/fzf-tab/fzf-tab.zsh"
safe_source "$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
safe_source "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
export ZSH_AUTOSUGGEST_STRATEGY=(completion)

# LS_COLORS for file type coloring (matches l script: blue=dir, green=exec, cyan=link, red=broken)
export LS_COLORS='di=34:ex=32:ln=36:or=31:mi=31:pi=33:so=35:bd=33:cd=33'

# Completion colors (used by fzf-tab)
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' fzf-flags --no-preview --height=~50% \
  --bind='shift-up:toggle+up,shift-down:toggle+down' \
  --bind='ctrl-a:select-all,ctrl-d:deselect-all'

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

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$("$HOME/mambaforge/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/mambaforge/etc/profile.d/conda.sh" ]; then
        . "$HOME/mambaforge/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/mambaforge/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "$HOME/mambaforge/etc/profile.d/mamba.sh" ]; then
    . "$HOME/mambaforge/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

