#!/bin/zsh
# Environment setup - runs once at login

# ─────────────────────────────────────────────────────────────────────────────
# Core environment variables
# ─────────────────────────────────────────────────────────────────────────────

export LOCAL_PREFIX="$HOME/.local"
export GLOBAL_PREFIX="/usr/local"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

# ─────────────────────────────────────────────────────────────────────────────
# Shell helpers (must come before everything else)
# ─────────────────────────────────────────────────────────────────────────────

if [[ -f "$HOME/.local/lib/shell/lib.zsh" ]]; then
  source "$HOME/.local/lib/shell/lib.zsh"
else
  # Fresh install - prompt user to run bootstrap
  if [[ -x "$HOME/.dotfiles/bootstrap" ]]; then
    echo "Run ~/.dotfiles/bootstrap to complete setup" >&2
  fi
  return 0
fi

# ─────────────────────────────────────────────────────────────────────────────
# Temporary directories
# ─────────────────────────────────────────────────────────────────────────────

export SCDIR="$HOME/scratch"
export DLDIR="$HOME/downloads"
temp_symlink "$SCDIR" "scratch"
temp_symlink "$DLDIR" "downloads"

# ─────────────────────────────────────────────────────────────────────────────
# Path management (zu)
# ─────────────────────────────────────────────────────────────────────────────

ensure_paths_dir

# Init lmod if available
safe_source "${MODULESHOME}/init/zsh"

# Install zu
LOG_DIR="$LOCAL_PREFIX/log/install"
run_install "zu" "$HOME/.config/install/zu" "$LOG_DIR"

# Load paths (zu must be available)
export PATH="$LOCAL_PREFIX/share/zu/bin:$PATH"
safe_eval "path read" --warn

# Bootstrap homebrew paths if needed
if has_cmd brew && [[ ! -f "$HOME/.paths/brew" ]]; then
  local brew_prefix="$(brew --prefix)"
  ensure_dir "$HOME/.paths"
  printf "%s\n" "$brew_prefix/bin" "$brew_prefix/sbin" > "$HOME/.paths/brew"
fi

# ─────────────────────────────────────────────────────────────────────────────
# Environment variables
# ─────────────────────────────────────────────────────────────────────────────

safe_eval "envs read"

# ─────────────────────────────────────────────────────────────────────────────
# Program installation
# ─────────────────────────────────────────────────────────────────────────────

safe_source "$HOME/.config/install/install" --warn

# ─────────────────────────────────────────────────────────────────────────────
# macOS-specific settings
# ─────────────────────────────────────────────────────────────────────────────

if [[ "$OSTYPE" == "darwin"* ]]; then
  # Turn 'quit unexpectedly' messages into notifications
  defaults write com.apple.CrashReporter UseUNC 1

  # Custom screenshot location
  export SSDIR="$HOME/screenshots"
  ensure_dir "$SSDIR"
  defaults write com.apple.screencapture location -string "$SSDIR"
fi
