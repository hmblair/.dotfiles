#!/bin/zsh
# Environment setup - runs once at login
#
# Local customization (not tracked in git):
#   ~/.paths/      Device-specific PATH entries (one path per line)
#   ~/.aliases     Device-specific aliases (sourced by .zshrc)
#   ~/.envs/       Device-specific env vars (managed by `envs` command)
#
# Use `envs add VAR value` to add environment variables
# Use `path add /path/to/bin` to add paths

# ─────────────────────────────────────────────────────────────────────────────
# Core environment variables
# ─────────────────────────────────────────────────────────────────────────────

export LOCAL_PREFIX="$HOME/.local"
export GLOBAL_PREFIX="/usr/local"
export XDG_CONFIG_HOME="$HOME/.config"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"
if [[ "$OSTYPE" == "linux"* ]]; then
  export XCURSOR_THEME=Adwaita
  export XCURSOR_SIZE=48
fi

# ─────────────────────────────────────────────────────────────────────────────
# Shell helpers (must come before everything else)
# ─────────────────────────────────────────────────────────────────────────────

if [[ -f "$HOME/.local/lib/shell/lib.zsh" ]]; then
  source "$HOME/.local/lib/shell/lib.zsh"
else
  # Fresh install - prompt user to run bootstrap
  if [[ -x "$HOME/.dotfiles/.bootstrap" ]]; then
    echo "Run ~/.dotfiles/.bootstrap to complete setup" >&2
  fi
  return 0
fi

# ─────────────────────────────────────────────────────────────────────────────
# Path management (zu)
# ─────────────────────────────────────────────────────────────────────────────

ensure_paths_dir

# Init lmod if available
safe_source "${MODULESHOME}/init/zsh"

# Install zu
LOG_DIR="$LOCAL_PREFIX/log/install"
run_install "zu" "$HOME/.config/install/zu" "$LOG_DIR"

# Load paths (zu must be available, and scripts need zsh in PATH)
export PATH="$LOCAL_PREFIX/bin:$LOCAL_PREFIX/share/zu/bin:$PATH"
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

safe_source "$HOME/.config/install/install" --warn "$@"

# ─────────────────────────────────────────────────────────────────────────────
# Temporary directories
# ─────────────────────────────────────────────────────────────────────────────

export SCDIR="$HOME/scratch"
export DLDIR="$HOME/downloads"
temp_symlink "$SCDIR" "scratch"
temp_symlink "$DLDIR" "downloads"

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

export ZPROFILE_SOURCED=1
