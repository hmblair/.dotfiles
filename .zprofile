#!/bin/zsh

# Unified install prefixes
export LOCAL_PREFIX="$HOME/.local"
export GLOBAL_PREFIX="/usr/local"

# Ensure UTF-8 locale

export LC_ALL="${LC_ALL:-en_US.UTF-8}"

# Scratch directory

export SCDIR="$HOME/scratch"
if [[ -L "$SCDIR" && ! -e "$SCDIR" ]]; then
    rm "$SCDIR"
fi
mkdir -p "/tmp/scratch"
ln -sfn "/tmp/scratch" "$SCDIR"

# Download directory

export DLDIR="$HOME/downloads"
if [[ -L "$DLDIR" && ! -e "$DLDIR" ]]; then
    rm "$DLDIR"
fi
mkdir -p "/tmp/downloads"
ln -sfn "/tmp/downloads" "$DLDIR"

# Bootstrap user-defined paths

if [[ ! -f "$HOME/.paths/boot" ]]; then
    touch "$HOME/.paths/boot"
    echo "$LOCAL_PREFIX/bin" >> "$HOME/.paths/boot"
fi

# Init lmod if available (before installs so we can use modules)

if [[ -n "$MODULESHOME" && -f "$MODULESHOME/init/zsh" ]]; then
    source "$MODULESHOME/init/zsh"
fi

# Install and init zu (before envs, as envs depends on zu)

LOG_DIR="$LOCAL_PREFIX/log/install"
mkdir -p "$LOG_DIR"
_zu_existed=0
[[ -d "$LOCAL_PREFIX/share/zu" ]] && _zu_existed=1
: > "$LOG_DIR/zu.log"
if source "$HOME/.config/install/zu" > "$LOG_DIR/zu.log" 2>&1; then
    if (( !_zu_existed )) && [[ -d "$LOCAL_PREFIX/share/zu" ]]; then
        printf "  %-20s\033[0;32m%s\033[0m\n" "zu" "OK"
    fi
else
    printf "  %-20s\033[0;31m%s\033[0m\n" "zu" "FAILED (see $LOG_DIR/zu.log)"
fi
unset _zu_existed

export PATH="$LOCAL_PREFIX/share/zu/bin:$PATH"
eval "$(path read)"

# Add homebrew paths if installed

if command -v brew &> /dev/null && [ ! -f "$HOME/.paths/brew" ]; then
    touch "$HOME/.paths/brew"
    echo "$(brew --prefix)/bin" >> "$HOME/.paths/brew"
    echo "$(brew --prefix)/sbin" >> "$HOME/.paths/brew"
fi

# Load user-defined environment variables

command -v envs &>/dev/null && eval "$(envs read)"

# Install and update core programs

source "$HOME/.config/install/install"


# macOS-specific settings

if [[ "$OSTYPE" == "darwin"* ]]; then
    # Turn 'quit unexpectedly' messages into notifications
    defaults write com.apple.CrashReporter UseUNC 1

    # Custom screenshot location
    export SSDIR="$HOME/screenshots"
    mkdir -p "$SSDIR"
    defaults write com.apple.screencapture location -string "$SSDIR"
fi
