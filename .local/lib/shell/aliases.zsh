#!/usr/bin/env zsh
# Generic shell aliases and functions (portable across machines)

# Safe defaults
alias mv="mv -i"
alias rsync="rsync -azh --progress"

# Editor shortcuts
alias py="python3"
alias v="nvim"
alias vi="nvim"
alias vim="nvim"


# Functions

source() {
  if [[ $# -eq 0 ]]; then
    builtin source ~/.zshrc
  else
    builtin source "$@"
  fi
}

ssh-terminfo() {
  infocmp -x | ssh "$1" 'mkdir -p ~/.terminfo && tic -x -'
  ssh "$1" 'grep -qF "resize()" ~/.bashrc 2>/dev/null || cat >> ~/.bashrc << '\''EOF'\''
resize() {
  old=$(stty -g)
  stty raw -echo min 0 time 5
  printf '\''\033[18t'\'' > /dev/tty
  IFS='\'';t'\'' read -r _ rows cols _ < /dev/tty
  stty "$old"
  stty cols "$cols" rows "$rows"
}
EOF'
}

resize() {
  old=$(stty -g)
  stty raw -echo min 0 time 5
  printf '\033[18t' > /dev/tty
  IFS=';t' read -r _ rows cols _ < /dev/tty
  stty "$old"
  stty cols "$cols" rows "$rows"
}

btop() {
  if [[ $COLUMNS -lt 80 || $LINES -lt 24 ]]; then
    command btop --preset 1 "$@"
  else
    command btop "$@"
  fi
}
