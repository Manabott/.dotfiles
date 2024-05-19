

# Commands that should be applied only for interactive shells.
[[ $- == *i* ]] || return

HISTFILESIZE=100000
HISTSIZE=10000

shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar
shopt -s checkjobs

alias ..='cd ..'
alias flake-rebuild='nh os switch --hostname hyprnix'
alias flake-update='nh os switch --hostname hyprnix --update'
alias gcCleanup='nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot'
alias la='lsd -a'
alias lal='lsd -al'
alias ll='lsd -l'
alias ls='lsd'
alias sv='sudo nvim'
alias v='nvim'
alias rawr='dino go rawr'

if [[ ! -v BASH_COMPLETION_VERSINFO ]]; then
  . "/nix/store/h7rc4ajxx8lrqg1i6cr8zhvz15rd2g0y-bash-completion-2.11/etc/profile.d/bash_completion.sh"
fi

fastfetch
if [ -f $HOME/.bashrc-personal ]; then
  source $HOME/.bashrc-personal
fi

if [[ $TERM != "dumb" ]]; then
  eval "$(/etc/profiles/per-user/manabot/bin/starship init bash --print-full-init)"
fi

if test -n "$KITTY_INSTALLATION_DIR"; then
  export KITTY_SHELL_INTEGRATION="no-rc"
  source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"
fi

SPICETIFY_INSTALL=="~/.spicetify"
PATH="$PATH:~/.spicetify"

#!/usr/bin/env bash
#
# spark
# https://github.com/holman/spark
#
# Generates sparklines for a set of data.
#
# Here's a good web-based sparkline generator that was a bit of inspiration
# for spark:
#
#   https://datacollective.org/sparkblocks
#
# spark takes a comma-separated or space-separated list of data and then prints
# a sparkline out of it.
#
# Examples:
#
#   spark 1 5 22 13 53
#   # => ▁▁▃▂▇
#
#   spark 0 30 55 80 33 150
#   # => ▁▂▃▅▂▇
#
#   spark -h
#   # => Prints the spark help text.

# Generates sparklines.
#
# $1 - The data we'd like to graph.
_echo()
{
  if [ "X$1" = "X-n" ]; then
    shift
    printf "%s" "$*"
  else
    printf "%s\n" "$*"
  fi
}

spark()
{
  local n numbers=

  # find min/max values
  local min=0xffffffff max=0

  for n in ${@//,/ }
  do
    # on Linux (or with bash4) we could use `printf %.0f $n` here to
    # round the number but that doesn't work on OS X (bash3) nor does
    # `awk '{printf "%.0f",$1}' <<< $n` work, so just cut it off
    n=${n%.*}
    (( n < min )) && min=$n
    (( n > max )) && max=$n
    numbers=$numbers${numbers:+ }$n
  done

  # print ticks
  local ticks=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)

  # use a high tick if data is constant
  (( min == max )) && ticks=(▅ ▆)

  local f=$(( (($max-$min)<<8)/(${#ticks[@]}-1) ))
  (( f < 1 )) && f=1

  for n in $numbers
  do
    _echo -n ${ticks[$(( ((($n-$min)<<8)/$f) ))]}
  done
  _echo
}

# If we're being sourced, don't worry about such things
if [ "$BASH_SOURCE" == "$0" ]; then
  # Prints the help text for spark.
  help()
  {
    local spark=$(basename $0)
    cat <<EOF

    USAGE:
      $spark [-h|--help] VALUE,...

    EXAMPLES:
      $spark 1 5 22 13 53
      ▁▁▃▂█
      $spark 0,30,55,80,33,150
      ▁▂▃▄▂█
      echo 9 13 5 17 1 | $spark
      ▄▆▂█▁
EOF
  }

  # show help for no arguments if stdin is a terminal
  if { [ -z "$1" ] && [ -t 0 ] ; } || [ "$1" == '-h' ] || [ "$1" == '--help' ]
  then
    help
    exit 0
  fi

  spark ${@:-`cat`}
fi

#alias clear='clear; echo; echo; seq 1 tput cols | sort -r | spark | lolcat; echo; echo'

# Min, max for spark
min=1
max=99

alias sparkly='spark $(for i in $(seq 1 $(tput cols)); do printf $(($RANDOM%($max-$min+1)+$min)),; done)'
sparkly
