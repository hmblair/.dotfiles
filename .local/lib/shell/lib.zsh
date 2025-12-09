#!/usr/bin/env zsh
# Shell helper functions for .zprofile and .zshrc

# Print a warning to stderr (won't break command substitution)
warn() {
  printf "\033[0;33mwarning:\033[0m %s\n" "$1" >&2
}

# Source a file if it exists, optionally warn if missing
# Usage: safe_source <file> [--warn]
# Returns 0 if file missing (no-op) or sourced successfully
safe_source() {
  local file="$1"
  if [[ -f "$file" ]]; then
    source "$file"
  elif [[ "$2" == "--warn" ]]; then
    warn "file not found: $file"
  fi
  return 0
}

# Create a directory if it doesn't exist
ensure_dir() {
  [[ -d "$1" ]] || mkdir -p "$1"
}

# Create a symlink to a temp directory, cleaning up broken links
# Usage: temp_symlink <link_path> <target_subdir>
temp_symlink() {
  local link="$1" subdir="$2"
  local target="/tmp/$subdir"
  # Remove broken symlink
  [[ -L "$link" && ! -e "$link" ]] && rm "$link"
  # Create target and link if needed
  if [[ ! -e "$link" ]]; then
    mkdir -p "$target"
    ln -sfn "$target" "$link"
  fi
}

# Run an install script with logging and status output
# Usage: run_install <name> <script_path> <log_dir>
run_install() {
  local name="$1" script="$2" log_dir="$3"
  local log_file="$log_dir/$name.log"
  local existed=0

  ensure_dir "$log_dir"
  : > "$log_file"

  # Track if this is a fresh install (for zu specifically)
  [[ -d "$LOCAL_PREFIX/share/$name" ]] && existed=1

  if source "$script" > "$log_file" 2>&1; then
    if (( !existed )) && [[ -d "$LOCAL_PREFIX/share/$name" ]]; then
      printf "  %-20s\033[0;32m%s\033[0m\n" "$name" "OK"
    fi
    return 0
  else
    printf "  %-20s\033[0;31m%s\033[0m\n" "$name" "FAILED (see $log_file)"
    return 1
  fi
}

# Ensure ~/.paths directory exists and bootstrap if needed
ensure_paths_dir() {
  local paths_dir="$HOME/.paths"
  ensure_dir "$paths_dir"
  if [[ ! -f "$paths_dir/boot" ]]; then
    echo "${LOCAL_PREFIX:-$HOME/.local}/bin" > "$paths_dir/boot"
  fi
}

# Check if a command exists
has_cmd() {
  command -v "$1" &>/dev/null
}

# Safely eval command output, with optional warning on failure
# Usage: safe_eval <cmd> [--warn]
# Returns 0 if command missing (no-op) or eval'd successfully
safe_eval() {
  local cmd="$1" output
  if has_cmd "${cmd%% *}"; then
    output="$(eval "$cmd" 2>/dev/null)"
    if [[ $? -eq 0 && -n "$output" ]]; then
      eval "$output"
    elif [[ "$2" == "--warn" ]]; then
      warn "failed to eval: $cmd"
    fi
  fi
  return 0
}

# Source all files in a directory
# Usage: source_dir <dir>
source_dir() {
  local dir="$1"
  [[ -d "$dir" ]] || return 0
  for file in "$dir"/*; do
    [[ -f "$file" ]] && source "$file"
  done
}
