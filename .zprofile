#!/bin/zsh

# Scratch directory

export SCDIR="$HOME/scratch"
mkdir -p "/tmp/scratch"
ln -sfn "/tmp/scratch" $SCDIR

# Download directory

export DLDIR="$HOME/downloads"
mkdir -p "/tmp/downloads"
ln -sfn "/tmp/downloads" $DLDIR

# Install homebrew and add paths

if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ ! -f $HOME/.paths/brew ]; then
  touch ~/.paths/brew
  echo $(brew --prefix)/bin >> ~/.paths/brew
  echo $(brew --prefix)/sbin >> ~/.paths/brew
fi

# Bootstrap user-defined paths

if [ ! -f $HOME/.paths/boot ]; then
  touch $HOME/.paths/boot
  echo "$HOME/.local/bin" >> $HOME/.paths/boot
fi

source ~/dev/zu/path read

# Load user-defined environment variables

if [ -f ~/.config/shell/env ]; then
  source ~/.config/shell/env
fi

# Turn the annoying 'quit unexpectedly' messages into notifications

if [[ "$OSTYPE" == "darwin"* ]]; then
  defaults write com.apple.CrashReporter UseUNC 1
fi

# Custom screenshot location

if [[ "$OSTYPE" == "darwin"* ]]; then
  export SSDIR="$HOME/screenshots"
  mkdir -p "$SSDIR"
  defaults write com.apple.screencapture location -string "$SSDIR"
fi
