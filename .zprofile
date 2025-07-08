#!/bin/zsh

# Add homebrew paths

eval "$(/opt/homebrew/bin/brew shellenv)"

# Bootstrap user-defined paths

export PATH=~/.local/bin:$PATH
if [ -f ~/.config/shell/paths ]; then
  source path read
fi

# Load user-defined environment variables

source ~/.config/shell/env
