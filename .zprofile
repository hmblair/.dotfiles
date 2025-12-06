#!/bin/zsh

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
mkdir -p "/tmp/downloads"
ln -sfn "/tmp/downloads" "$DLDIR"

# Bootstrap user-defined paths

if [[ ! -f "$HOME/.paths/boot" ]]; then
    touch "$HOME/.paths/boot"
    echo "$HOME/.local/bin" >> "$HOME/.paths/boot"
fi

# Init lmod if available (before installs so we can use modules)

if [[ -n "$MODULESHOME" && -f "$MODULESHOME/init/zsh" ]]; then
    source "$MODULESHOME/init/zsh"
fi

# Install and update core programs

source "$HOME/.config/install/install"

# Init zu

source "$HOME/.local/share/zu/path/path" read

# Add homebrew paths if installed

if command -v brew &> /dev/null && [ ! -f "$HOME/.paths/brew" ]; then
    touch "$HOME/.paths/brew"
    echo "$(brew --prefix)/bin" >> "$HOME/.paths/brew"
    echo "$(brew --prefix)/sbin" >> "$HOME/.paths/brew"
fi

# Load user-defined environment variables

eval "$(envs read)"

# macOS-specific settings

if [[ "$OSTYPE" == "darwin"* ]]; then
    # Turn 'quit unexpectedly' messages into notifications
    defaults write com.apple.CrashReporter UseUNC 1

    # Custom screenshot location
    export SSDIR="$HOME/screenshots"
    mkdir -p "$SSDIR"
    defaults write com.apple.screencapture location -string "$SSDIR"
fi
