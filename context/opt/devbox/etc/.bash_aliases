# shellcheck shell=bash disable=SC1090,SC1091,SC2139
#  _               _              _ _
# | |__   __ _ ___| |__      __ _| (_) __ _ ___  ___  ___
# | '_ \ / _` / __| '_ \    / _` | | |/ _` / __|/ _ \/ __|
# | |_) | (_| \__ \ | | |  | (_| | | | (_| \__ \  __/\__ \
# |_.__/ \__,_|___/_| |_|___\__,_|_|_|\__,_|___/\___||___/
#                       |_____|
# ========================================================
#
# Bash Aliases file.

#-----------------------------------------------------------------------------
# LS COLORS
#-----------------------------------------------------------------------------
# @see: https://gist.github.com/seantrane/e13706494a54bd3a6c2456608ea68c7e

# Detect which `ls` flavor is in use.
# FreeBSD, older versions of macOS, have different ls command.
if ls --color >/dev/null 2>&1; then
  colorflag="--color=always"
else
  colorflag="-G"
fi
# Use GNU ls, if installed by Homebrew.
# Always use color output for `ls`.
if [[ -n "${HOMEBREW_PREFIX:-}" ]] && [[ -r "${HOMEBREW_PREFIX:-}/bin/gls" ]]; then
  # shellcheck disable=SC2262
  alias ls="command ${HOMEBREW_PREFIX:-}/bin/gls --color=always --group-directories-first"
else
  alias ls="command ls ${colorflag}"
fi
# Set time style flag, according to `ls` flavor.
# shellcheck disable=SC2263
if [[ -n "${HOMEBREW_PREFIX:-}" ]] && [[ ! -r "${HOMEBREW_PREFIX:-}/bin/gls" ]] && ls -T >/dev/null 2>&1; then
  timeflag="-T"
else
  timeflag="--time-style=long-iso"
fi
# List all files colorized in long format.
alias l="ls -lhF ${timeflag}"
# List all files colorized in long format, including dot files.
alias la="ls -lahF ${timeflag}"
# List, rescursively, all files colorized in long format, including dot files.
alias lsr="ls -lahFR ${timeflag}"
# List only directories
if type sed &>/dev/null; then
  alias lsd="ls -AhF ${timeflag} | sed '/[^\/]$/d'"
  alias lsdl="ls -lAhF ${timeflag} | sed '/^[-l]/d'"
else
  alias lsd="ls -dA ${timeflag} */"
  alias lsdl="ls -dlAhF ${timeflag} */"
fi

#-----------------------------------------------------------------------------
# ALIASES
#-----------------------------------------------------------------------------
# Aliases should only be available to prompt-user (not scripts).

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"

# Enable aliases to be sudo’ed
# alias sudo='sudo '
# alias nsudo='nocorrect sudo'
# alias sudo='my_sudo '
# function my_sudo {
#   while [[ $# -gt 0 ]]; do
#     case "$1" in
#     command)
#       shift
#       break
#       ;;
#     nocorrect | noglob) shift ;;
#     *) break ;;
#     esac
#   done
#   if [[ $# = 0 ]]; then
#     command sudo zsh
#   else
#     # shellcheck disable=SC2068
#     noglob command sudo $@
#   fi
# }
# shellcheck disable=SC2120
# sudo() {
#   if alias "$1" &>/dev/null; then
#     $(type "$1" | sed -E 's/^.*`(.*).$/\1/') "${@:2}"
#   elif [[ -n "$1" ]]; then
#     command sudo "$@"
#   else
#     command sudo -n true
#   fi
# }

# Put OS to sleep/standby
alias sleepnow="pmset sleepnow"

# Get week number
alias week='date +%V'

# Stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Canonical hex dump; some systems have this symlinked
command -v hd >/dev/null || alias hd="hexdump -C"

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  alias "$method"="lwp-request -m '$method'"
done

alias npmlistg="npm list -g --depth=0 </dev/null 2>/dev/null"
alias npmlist="npm list --depth=0 </dev/null 2>/dev/null"

alias binstall="bundle install"
alias bjbuild="bundle exec jekyll build --incremental"
alias bjserve="bundle exec jekyll serve --incremental --watch"
alias bjbs="bjbuild && bjserve"

# `~/.aliases` can be used for private aliases.
[[ -f "$HOME/.aliases" ]] && . "$HOME/.aliases"
