#!/bin/zsh

# Add homebrew paths

eval "$(/opt/homebrew/bin/brew shellenv)"

# Bootstrap user-defined paths

export PATH=~/.local/bin:$PATH
source path read

# Load user-defined environment variables

source ~/.config/shell/env
