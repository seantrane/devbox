#!/usr/bin/env bash
#
# shellcheck disable=SC1090,SC1091

# Settings to ensure exit on errors.
# CI/CD, builds, and tests should not proceed if something has gone wrong.
# - https://gist.github.com/seantrane/2576d590db03bc67c9711abeeafca803
# set -Eeuo pipefail
# Enable 'expose' (print commands) and 'verbose' option for debugging.
# set -x
# set -v

# Use Bash, by default, if first argument is a CLI option
# (-f or --some-option) or there are no args.
# ex: docker run devbox -c 'echo hi'
if [ "$#" -eq 0 ] || [ "${1#-}" != "$1" ]; then
  exec bash "$@"
fi

# exec "$@"
bash -i -c "$*"
