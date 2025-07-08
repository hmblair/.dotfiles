#!/bin/zsh

# Add homebrew paths

if command -v /opt/homebrew/bin/brew &> /dev/null; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Bootstrap user-defined paths

export PATH=~/.local/bin:$PATH
if [ -f ~/.config/shell/paths ]; then
  source path read
fi

# Load user-defined environment variables

source ~/.config/shell/env
