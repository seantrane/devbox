# shellcheck shell=bash disable=SC1090,SC1091,SC2139
#  _               _
# | |__   __ _ ___| |__  _ __ ___
# | '_ \ / _` / __| '_ \| '__/ __|
# | |_) | (_| \__ \ | | | | | (__
# |_.__/ \__,_|___/_| |_|_|  \___|
# ================================
#
# Bash Run Control file.
#
# See table below for processing information.
#
# Bash executes A, then B, then C, etc.
# The B1, B2, B3 means it executes only the first of those files found.
# +-----------------+-----------+-----------+------+
# |                 |Interactive|Interactive|Script|
# |                 |login      |non-login  |      |
# +-----------------+-----------+-----------+------+
# |/etc/profile     |   A       |           |      |
# +-----------------+-----------+-----------+------+
# |/etc/bash.bashrc |           |    A      |      |
# +-----------------+-----------+-----------+------+
# |  ~/.bashrc      |           |    B      |      |
# +-----------------+-----------+-----------+------+
# |  ~/.bash_profile|   B1      |           |      |
# +-----------------+-----------+-----------+------+
# |  ~/.bash_login  |   B2      |           |      |
# +-----------------+-----------+-----------+------+
# |  ~/.profile     |   B3      |           |      |
# +-----------------+-----------+-----------+------+
# |BASH_ENV         |           |           |  A   |
# +-----------------+-----------+-----------+------+
# +-----------------+-----------+-----------+------+
# |  ~/.bash_logout |    C      |           |      |
# +-----------------+-----------+-----------+------+
#
# Moral: Put stuff in `~/.bashrc `, make `~/.bash_profile` source it.
#
# Almost everything should go in the “general configuration” section.
# There might be some commands (those which produce output, etc.)
# that you only want executed when the shell is interactive, and
# not in scripts, which you can put in the “conditional section”.

#-------------------------------------------------------------------------------
# Load `.env`
#-------------------------------------------------------------------------------
# This file should be loaded first in all shell environments,
# in the following files; `~/.bashrc` and `~/.zshenv`

# . ~/.env
[[ -f "$HOME/.env" ]] && . "$HOME/.env"

#-------------------------------------------------------------------------------
# PATHS
#-------------------------------------------------------------------------------

# PATH / MANPATH exports
# Defines the $PATH export/variable for shell environments.

# DEFAULT `$PATH`
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Add `~/.local/{sbin,bin}` to the `$PATH`
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
[[ -d "$HOME/.local/sbin" ]] && export PATH="$HOME/.local/sbin:$PATH"

# Add `~/{sbin,bin}` to the `$PATH`
[[ -d "$HOME/bin" ]] && export PATH="$HOME/bin:$PATH"
[[ -d "$HOME/sbin" ]] && export PATH="$HOME/sbin:$PATH"

# Add Go to PATH.
[[ -d "/usr/local/go/bin" ]] && export PATH="$PATH:/usr/local/go/bin"

# Add Yarn to PATH.
type "yarn" &>/dev/null && PATH="$(yarn global bin):$PATH"

# Enable GCP
if [[ -d "/google-cloud-sdk" ]]; then
  . /google-cloud-sdk/path.bash.inc
  . /google-cloud-sdk/completion.bash.inc
  PATH="$PATH:/google-cloud-sdk/bin"
fi

[[ -d "/opt/dependency-check/bin" ]] && export PATH="$PATH:/opt/dependency-check/bin"

# Homebrew path must come first to override system binaries.
[[ -d "${HOMEBREW_PREFIX:-}/bin" ]] && export PATH="${HOMEBREW_PREFIX:-}/bin:$PATH"

# Add DevBox binaries to PATH.
[[ -d "/opt/devbox/bin" ]] && export PATH="/opt/devbox/bin:$PATH"

# Add ./bin directory, if available, from active PWD.
[[ -d "$(pwd)/bin" ]] && PATH="$(pwd)/bin:$PATH"

# HELP DOCS/MANUALS
[[ -d "${HOMEBREW_PREFIX:-}/man" ]] && export MANPATH="${HOMEBREW_PREFIX:-}/man:$MANPATH"
# .local manuals:
[[ -d "$HOME/.local/man" ]] && export MANPATH="$HOME/.local/man:$MANPATH"

# . ~/.paths
[[ -f "$HOME/.paths" ]] && . "$HOME/.paths"

# CLEANUP PATH, MANPATH - Ensure arrays do not contain duplicates.
if type "awk" &>/dev/null; then
  PATH=$(echo -n "$PATH" | awk -v RS=: '{ if (!arr[$0]++) {printf("%s%s",!ln++?"":":",$0)}}')

  MANPATH=$(echo -n "$MANPATH" | awk -v RS=: '{ if (!arr[$0]++) {printf("%s%s",!ln++?"":":",$0)}}')
fi

export LDFLAGS CPPFLAGS PKG_CONFIG_PATH
export PATH MANPATH INFOPATH

#-------------------------------------------------------------------------------
# DEFAULT VARIABLES
#-------------------------------------------------------------------------------

# EDITORS
# Use VIM, by default
EDITOR="vim"
VISUAL="$EDITOR"
if type "code" &>/dev/null; then
  # Use VS Code, if available
  EDITOR="code"
  VISUAL="$EDITOR"
elif type "nvim" &>/dev/null; then
  # Use Neovim, if available
  EDITOR="nvim"
  VISUAL="$EDITOR"
  alias vi="nvim"
elif ! type "vim" &>/dev/null && type "nano" &>/dev/null; then
  # Use Nano, as a fallback
  EDITOR="nano"
  VISUAL="$EDITOR"
elif ! type "vim" &>/dev/null && type "pico" &>/dev/null; then
  # Use Pico, as a fallback
  EDITOR="pico"
  VISUAL="$EDITOR"
fi
export EDITOR VISUAL

# LESS > MORE
export PAGER="less"
export NULLCMD="cat"
export READNULLCMD="$PAGER"

# LANGUAGE
[[ -z "$LANG" ]] && export LANG="en_US.UTF-8"

#-------------------------------------------------------------------------------
# Shell Response Text/Colors/Helpers
#-------------------------------------------------------------------------------

# Color Switch
export SWITCH='\033['

# Clear whole line and hard-line-return
export ClearLine="${SWITCH}2K"
export ClearLineReturn="${ClearLine}\r"
export ClearNewLine="${ClearLineReturn}\n"

# Text Attributes
export Reset="${SWITCH}0m"
export Bold="${SWITCH}1m"
export Dim="${SWITCH}2m"
export Underline="${SWITCH}4m"
export Blink="${SWITCH}5m"
export Reverse="${SWITCH}7m"
export Hidden="${SWITCH}8m"

# Regular Colors
export Black="${SWITCH}0;30m"
export Red="${SWITCH}0;31m"
export Green="${SWITCH}0;32m"
export Yellow="${SWITCH}0;33m"
export Blue="${SWITCH}0;34m"
export Magenta="${SWITCH}0;35m"
export Cyan="${SWITCH}0;36m"
export White="${SWITCH}0;37m"
export Default="${SWITCH}0;39m"

# Bold
export BBlack="${SWITCH}1;30m"
export BRed="${SWITCH}1;31m"
export BGreen="${SWITCH}1;32m"
export BYellow="${SWITCH}1;33m"
export BBlue="${SWITCH}1;34m"
export BMagenta="${SWITCH}1;35m"
export BCyan="${SWITCH}1;36m"
export BWhite="${SWITCH}1;37m"
export BDefault="${SWITCH}1;39m"

# Underline
export UBlack="${SWITCH}4;30m"
export URed="${SWITCH}4;31m"
export UGreen="${SWITCH}4;32m"
export UYellow="${SWITCH}4;33m"
export UBlue="${SWITCH}4;34m"
export UMagenta="${SWITCH}4;35m"
export UCyan="${SWITCH}4;36m"
export UWhite="${SWITCH}4;37m"
export UDefault="${SWITCH}4;39m"

# Background
export BGBlack="${SWITCH}40m"
export BGRed="${SWITCH}41m"
export BGGreen="${SWITCH}42m"
export BGYellow="${SWITCH}43m"
export BGBlue="${SWITCH}44m"
export BGMagenta="${SWITCH}45m"
export BGCyan="${SWITCH}46m"
export BGWhite="${SWITCH}47m"
export BGDefault="${SWITCH}49m"

# High Intensity
export IBlack="${SWITCH}0;90m"
export IRed="${SWITCH}0;91m"
export IGreen="${SWITCH}0;92m"
export IYellow="${SWITCH}0;93m"
export IBlue="${SWITCH}0;94m"
export IMagenta="${SWITCH}0;95m"
export ICyan="${SWITCH}0;96m"
export IWhite="${SWITCH}0;97m"
export IDefault="${SWITCH}0;99m"

# Bold High Intensity
export BIBlack="${SWITCH}1;90m"
export BIRed="${SWITCH}1;91m"
export BIGreen="${SWITCH}1;92m"
export BIYellow="${SWITCH}1;93m"
export BIBlue="${SWITCH}1;94m"
export BIMagenta="${SWITCH}1;95m"
export BICyan="${SWITCH}1;96m"
export BIWhite="${SWITCH}1;97m"
export BIDefault="${SWITCH}1;99m"

# High Intensity backgrounds
export BGIBlack="${SWITCH}0;100m"
export BGIRed="${SWITCH}0;101m"
export BGIGreen="${SWITCH}0;102m"
export BGIYellow="${SWITCH}0;103m"
export BGIBlue="${SWITCH}0;104m"
export BGIMagenta="${SWITCH}0;105m"
export BGICyan="${SWITCH}0;106m"
export BGIWhite="${SWITCH}0;107m"
export BGIDefault="${SWITCH}0;109m"

#-------------------------------------------------------------------------------
# CUSTOM/USER VARIABLES
#-------------------------------------------------------------------------------
# `~/.exports` can be used for private variables.

[[ -f "$HOME/.exports" ]] && . "$HOME/.exports"

################################################################################
################################################################################
##
##  GENERAL CONFIGURATION
##  (stuff that you always want executed)
##
################################################################################
################################################################################

#-------------------------------------------------------------------------------
# FUNCTIONS
#-------------------------------------------------------------------------------

# autoload every function:
if [[ -d "/opt/devbox/lib/functions" ]]; then
  # for file in ~/dotfiles/functions/{extract,link_file}.sh; do
  # shellcheck disable=SC2044
  for _file in $(find -H "/opt/devbox/lib/functions" -maxdepth 2 -perm -u+r -type f -name '[A-Za-z0-9\-\_]*.sh'); do
    . "$_file"
  done
  unset _file
fi

# autoload every function:
if [[ -d "$HOME/.functions" ]]; then
  # for file in ~/.functions/{extract,link_file}.sh; do
  # shellcheck disable=SC2044
  for _file in $(find -H "$HOME/.functions" -maxdepth 2 -perm -u+r -type f -name '[A-Za-z0-9\-\_]*.sh'); do
    . "$_file"
  done
  unset _file
fi

################################################################################
##  THE END: GENERAL CONFIGURATION
################################################################################

################################################################################
################################################################################
##
##  1a. SCRIPT / NON-INTERACTIVE / .bash_env
##
##  Only for NON-interactive shells (ie; scripts)
##  See `~/.bash_env` for bash-script-resources.
##  Bash scripts typically would not process this file,
##  so this section can be ignored unless required.
##
################################################################################
if [[ -z "$PS1" ]]; then
  : ############################################################################
# echo "$SHELL"

################################################################################
################################################################################
##
##  1b. INTERACTIVE / PROMPT / .bashrc
##
##  This is executed only for interactive shells.
##  If you have a command-prompt, this conditional was met.
##  Put stuff here for prompt-based users only.
##
################################################################################
else
  : ############################################################################
  # echo "$SHELL::interactive"

  #-----------------------------------------------------------------------------
  # RUN-CONTROLS
  #-----------------------------------------------------------------------------

  # GRC colorizes nifty unix tools all over the place
  if type "grc" &>/dev/null; then
    # Homebrew GRC: https://github.com/Homebrew/homebrew/blob/master/Library/Formula/grc.rb
    if type "brew" &>/dev/null && [[ -f "$(brew --prefix)/etc/grc.bashrc" ]]; then
      . "$(brew --prefix)/etc/grc.bashrc"
    elif [[ -f "/etc/grc.bashrc" ]]; then
      . "/etc/grc.bashrc"
    fi
  fi

  # Stash your environment variables in ~/.localrc. This means they'll stay out
  # of your main dotfiles repository (which may be public, like this one), but
  # you'll have access to them in your scripts.
  [[ -f "$HOME/.localrc" ]] && . "$HOME/.localrc"

  #-----------------------------------------------------------------------------
  # PROMPT OPTIONS
  #-----------------------------------------------------------------------------

  # Bash Prompt
  # https://ss64.com/bash/syntax-prompt.html
  # Variables that control the appearance of the bash command prompt:
  #   PS1 – Default interactive prompt (this is the variable most often customized)
  #   PS2 – Continuation interactive prompt (when a long command is broken up with \ at the end of the line) default=">"
  #   PS3 – Prompt used by “select” loop inside a shell script
  #   PS4 – Prompt used when a shell script is executed in debug mode (“set -x” will turn this on) default ="++"
  #   PROMPT_COMMAND - If this variable is set and has a non-null value, then it will be executed just before the PS1 variable.
  #
  # Shell prompt based on the Prezto Sorin theme for Zsh.
  #
  # iTerm → Profiles → Text → use 13pt Menlo/Monaco with 1.1 vertical spacing.

  if [[ $COLORTERM = gnome-* ]] && [[ $TERM = xterm ]] && infocmp gnome-256color &>/dev/null; then
    export TERM="gnome-256color"
  elif infocmp xterm-256color >/dev/null 2>&1; then
    export TERM="xterm-256color"
  fi

  if tput setaf 1 &>/dev/null; then
    tput sgr0 # reset colors
    bold=$(tput bold)
    reset=$(tput sgr0)
    # Default (http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html)
    black=$(tput setaf 0)
    dkgray=$(tput setaf 238)
    gray=$(tput setaf 8)
    ltgray=$(tput setaf 248)
    blue=$(tput setaf 33)
    cyan=$(tput setaf 45)
    green=$(tput setaf 70)
    orange=$(tput setaf 208)
    purple=$(tput setaf 93)
    red=$(tput setaf 160)
    violet=$(tput setaf 141)
    white=$(tput setaf 15)
    yellow=$(tput setaf 11)
    # Solarized (http://git.io/solarized-colors)
    # black=$(tput setaf 0)
    # blue=$(tput setaf 33)
    # cyan=$(tput setaf 37)
    # green=$(tput setaf 64)
    # orange=$(tput setaf 166)
    # purple=$(tput setaf 125)
    # red=$(tput setaf 124)
    # violet=$(tput setaf 61)
    # white=$(tput setaf 15)
    # yellow=$(tput setaf 136)
    # Custom
    dkgray=$(tput setaf 239)
    green=$(tput setaf 76)
  else
    bold="\e[1"
    reset="\e[0m"
    black="\e[0;30m"
    dkgray="\e[1;30m"
    gray="\e[1;39m"
    ltgray="\e[0;37m"
    blue="\e[1;34m"
    cyan="\e[1;36m"
    green="\e[1;32m"
    orange="\e[0;33m"
    purple="\e[0;35m"
    red="\e[1;31m"
    violet="\e[1;35m"
    white="\e[1;37m"
    yellow="\e[1;33m"
  fi
  # Add escape characters for sequence of non-printing characters (like color escape sequences).
  # This allows bash to calculate word wrapping correctly.
  bold="\[$bold\]"
  reset="\[$reset\]"
  black="\[$black\]"
  dkgray="\[$dkgray\]"
  gray="\[$gray\]"
  ltgray="\[$ltgray\]"
  blue="\[$blue\]"
  cyan="\[$cyan\]"
  green="\[$green\]"
  orange="\[$orange\]"
  purple="\[$purple\]"
  red="\[$red\]"
  violet="\[$violet\]"
  white="\[$white\]"
  yellow="\[$yellow\]"

  ##############################################################################
  # Display git info and status for shell prompt.
  # Definitions for prompt-git-icons:
  #   - '◀︎' = # of commits behind origin branch.
  #   - '▶︎' = # of commits ahead origin branch.
  #   - '#' = # of total changes in index, work tree.
  #   - 'M' = Modified in index / work tree changed since index.
  #   - 'T' = File type changed in index. File type changed in work tree since index.
  #   - 'A' = Added from index, work tree.
  #   - 'D' = Deleted from index, work tree.
  #   - 'R' = Renamed in index, work tree.
  #   - 'C' = Copied in index, work tree.
  #   - 'U' = Unmerged, both modified.
  #   - '?' = Untracked files.
  #   - '!' = Ignored files.
  #   - '$' = Stashed files.
  # Globals:
  #   git
  # Options:
  #   None
  # Arguments:
  #   None
  # Returns:
  #   If directoy is a git repo, prints to STDOUT...
  #   Active git branch and icons representing git status...
  #   git:main 2◀︎ ▶︎1 (3) M T A D R C U ? ! $
  ##############################################################################
  prompt_git() {
    local working_dir_path="${1:-$PWD}"
    local git_icons=''
    local branch_name=''
    local change_count
    # Check if the current directory is in a Git repository.
    if type "git" &>/dev/null && [[ "$(
      cd "$working_dir_path"
      git rev-parse --is-inside-work-tree &>/dev/null
      echo ${?}
    )" == '0' ]]; then
      # check if the current directory is in .git before running git checks
      if [[ "$(
        cd "$working_dir_path"
        git rev-parse --is-inside-git-dir 2>/dev/null
      )" == 'false' ]]; then
        # Ensure the index is up to date.
        git update-index --really-refresh -q &>/dev/null
        # Get git status output, in parse-ready format.
        # Info: https://git-scm.com/docs/git-status
        git_status_output="$(
          cd "$working_dir_path" || return
          git status -b --show-stash --porcelain -u --ignore-submodules --ahead-behind --renames
        )"
        git_status_output_branch="$(echo "${git_status_output}" | head -1)"
        git_status_output_changes="$(echo "${git_status_output}" | tail -n +2)"
        [[ -n "$git_status_output_changes" ]] && change_count="$(echo "${git_status_output_changes}" | wc -l)"
        # Active branch name
        if [[ "$git_status_output_branch" =~ .*\#\#\ .+ ]]; then
          branch_name="${git_status_output_branch%\.\.\.*}"
          branch_name="${branch_name#\#\#\ }"
          branch_name="${branch_name#No\ commits\ yet\ on\ }"
          if [[ "$git_status_output_branch" =~ .*behind\ [0-9]+ ]]; then
            count_behind="${git_status_output_branch%]*}"
            count_behind="${count_behind#*behind\ }"
            branch_name+=" ${red}${count_behind}◀︎"
          fi
          if [[ "$git_status_output_branch" =~ .*ahead\ [0-9]+ ]]; then
            count_ahead="${git_status_output_branch%]*}"
            count_ahead="${count_ahead#*ahead\ }"
            branch_name+=" ${violet}▶︎${count_ahead}"
          fi
        fi
        [[ "$change_count" -gt 0 ]] && branch_name+=" ${gray}(${change_count})"
        # Modified in index / work tree changed since index.
        if [[ "$git_status_output" =~ .*M[\ MTD]\ .+ ]] ||
          [[ "$git_status_output" =~ .*[\ MTARC]M\ .+ ]]; then
          git_icons+=" ${yellow}M"
        fi
        # File type changed in index. File type changed in work tree since index.
        if [[ "$git_status_output" =~ .*T[\ MTD]\ .+ ]] ||
          [[ "$git_status_output" =~ .*[\ MTARC]T\ .+ ]]; then
          git_icons+=" ${purple}T"
        fi
        # Added from index, work tree.
        if [[ "$git_status_output" =~ .*A[\ MTDU]\ .+ ]] ||
          [[ "$git_status_output" =~ .*[AU]A\ .+ ]]; then
          git_icons+=" ${green}A"
          [[ "$git_status_output" =~ .*UA\ .+ ]] && git_icons+="⬆︎" # unmerged, added by them
          [[ "$git_status_output" =~ .*AU\ .+ ]] && git_icons+="⬇︎" # unmerged, added by us
          [[ "$git_status_output" =~ .*AA\ .+ ]] && git_icons+="⬍"  # unmerged, both added
        fi
        # Deleted from index, work tree.
        if [[ "$git_status_output" =~ .*D[\ DU]\ .+ ]] ||
          [[ "$git_status_output" =~ .*[\ MTARC]D\ .+ ]]; then
          git_icons+=" ${red}D"
          [[ "$git_status_output" =~ .*UD\ .+ ]] && git_icons+="⬆︎" # unmerged, deleted by them
          [[ "$git_status_output" =~ .*DU\ .+ ]] && git_icons+="⬇︎" # unmerged, deleted by us
          [[ "$git_status_output" =~ .*DD\ .+ ]] && git_icons+="⬍"  # unmerged, both deleted
        fi
        # Renamed in index, work tree.
        if [[ "$git_status_output" =~ .*R[\ MTD]\ .+ ]] ||
          [[ "$git_status_output" =~ .*\ R\ .+ ]]; then
          git_icons+=" ${orange}R"
        fi
        # Copied in index, work tree.
        if [[ "$git_status_output" =~ .*C[\ MTD]\ .+ ]] ||
          [[ "$git_status_output" =~ .*\ C\ .+ ]]; then
          git_icons+=" ${gray}C"
        fi
        # Unmerged, both modified.
        [[ "$git_status_output" =~ .*UU\ .+ ]] && git_icons+=" ${yellow}U"
        # Untracked files.
        [[ "$git_status_output" =~ .*\?\?\ .+ ]] && git_icons+=" ${cyan}?"
        # Ignored files.
        [[ "$git_status_output" =~ .*\!\!\ .+ ]] && git_icons+=" ${dkgray}!"
        # Stashed files.
        if [[ "$git_status_output" =~ .*stash\ [0-9]+.* ]] ||
          [[ $(
            cd "$working_dir_path"
            git rev-parse --verify refs/stash &>/dev/null
          ) ]]; then
          git_icons+=" ${blue}$"
        fi

        # # Check for uncommitted changes in the index.
        # [[ ! $(cd "$working_dir_path"; git diff --quiet --ignore-submodules --cached) ]] && git_icons+=" ${violet}∆"
        # # Check for deleted files.
        # [[ -n "$(cd "$working_dir_path"; git ls-files --deleted)" ]] && git_icons+=" ${red}X"
        # # Check for modified files.
        # [[ -n "$(cd "$working_dir_path"; git ls-files --modified)" ]] && git_icons+=" ${yellow}M"
        # # Check for untracked files.
        # [[ -n "$(cd "$working_dir_path"; git ls-files --others --exclude-standard)" ]] && git_icons+=" ${green}U"
        # # Check for unstaged changes.
        # [[ ! $(cd "$working_dir_path"; git diff-files --quiet --ignore-submodules --) ]] && git_icons+=" ${white}■"
      fi
      # Get the short symbolic ref.
      # If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
      # Otherwise, just give up.
      [[ -z "$branch_name" ]] && branch_name="$(
        cd "$working_dir_path" || return
        git symbolic-ref --quiet --short HEAD 2>/dev/null ||
          git rev-parse --short HEAD 2>/dev/null ||
          git branch | tail -c +3 ||
          echo '(unknown)'
      )"

      echo "${violet}git${white}:${green}${branch_name}${git_icons}${reset}"
    fi
  }

  #-----------------------------------------------------------------------------
  # USER @ HOST (OS-MACH-ARCH):
  #-----------------------------------------------------------------------------

  PSUSERHOST="${gray}"
  # Highlight the user name when logged in as root.
  [[ "${USER:-}" == "root" ]] && PSUSERHOST="${red}"
  PSUSERHOST+=${USER:-$(id -un 2>/dev/null || echo "\u")}
  PSUSERHOST+="${dkgray} @ "
  # Highlight the hostname when connected via SSH.
  [[ "${SSH_TTY:-}" ]] && PSUSERHOST+="${bold}${red}"
  PSUSERHOST+=${HOST:-${HOSTNAME:-$(hostname 2>/dev/null || echo "\h")}}
  [[ "${SSH_TTY:-}" ]] && {
    PSUSERHOST+=-${UARCH:-${HOSTTYPE:-$(uname -p 2>/dev/null)}}
    PSUSERHOST+=-${UMACH:-${MACHTYPE:-$(uname -m 2>/dev/null)}}
  }
  PSUSERHOST+=" ${dkgray}(${UTYPE:-${OSTYPE:-$(uname 2>/dev/null)}})${reset}"

  #-----------------------------------------------------------------------------
  # PROMPT
  #-----------------------------------------------------------------------------

  # reduce directories shown in path
  export PROMPT_DIRTRIM=3

  # Set the terminal title to the current working directory.
  PSTITLE="\[\033]0;\w\007\]"

  ##############################################################################
  # Assemble time shell prompt content.
  # Returns:
  #   Prints to STDOUT; time, active user, host, os, shell, shell-version.
  #   [24:07:11]
  ##############################################################################
  function prompt_time() {
    # echo -e "${dkgray}[${gray}\\\t${dkgray}]"
    echo -e "${dkgray}[ ${gray}$(date +'%r')${dkgray} ]"
  }

  ##############################################################################
  # Assemble user/host shell prompt content.
  # Returns:
  #   Prints to STDOUT; time, active user, host, os, shell, shell-version.
  #   username @ hostname (system) bash5.1›
  ##############################################################################
  function prompt_userhost() {
    echo -e "${PSUSERHOST:-} ${dkgray}\s\\\\v›${reset}  "
  }

  ##############################################################################
  # Assemble main left-aligned shell prompt content.
  # Returns:
  #   Prints to STDOUT; active directory path and, if applicable, git info/status.
  #   .../short/dir/path (23) git:main 2◀︎ ▶︎1 (3) M T A D R C U ? ! $ ›››
  ##############################################################################
  function prompt_main() {
    # directory path for git status
    local working_dir_path="${1:-$PWD}"
    # directory path for prompt display
    local prompt_main="${cyan}\w"
    # number of files in directory
    prompt_main+=" ${dkgray}(\$(ls | wc -l))"
    # git status
    prompt_main+=" $(prompt_git "$working_dir_path")"
    prompt_main+=" ${red}❯${yellow}❯${green}❯${reset}  "
    echo -e "${prompt_main:-}"
  }

  ##############################################################################
  # Assemble right-aligned shell prompt content.
  # Returns:
  #   Prints to STDOUT; system language, charset, date, time.
  ##############################################################################
  function prompt_right() {
    echo -e "${dkgray}${LANG:-} [ $(date -u +'%Y-%m-%dT%T%:z') ]${reset}"
  }

  ##############################################################################
  # Assemble and set shell prompt (`PS1`). To be run by `PROMPT_COMMAND`.
  # Returns:
  #   None.
  ##############################################################################
  function prompt() {
    local working_dir_path="$PWD"
    local compensate=9
    if tput cols &>/dev/null; then
      PS1=$(printf "\n%s%*s\r%s\n%s\n%s" "$(prompt_time)" "$(($(tput cols) + compensate))" "$(prompt_right)" "${PSTITLE:-}" "$(prompt_userhost)" "$(prompt_main "$working_dir_path")" 2>/dev/null)
    else
      PS1=$(printf "%s\n%s %s\n%s" "${PSTITLE:-}" "$(prompt_time)" "$(prompt_userhost)" "$(prompt_main "$working_dir_path")" 2>/dev/null)
    fi
    # export PS1
  }

  # If set, it will be executed just before the PS1 variable.
  PROMPT_COMMAND=prompt

  # PS1 – Default interactive prompt
  # PS1="${PSTITLE:-}\n$(prompt_userhost)\n$(prompt_main "$PWD")"
  # export PS1

  # PS2 – Continuation interactive prompt (long command with \ at EOL) default=">"
  PS2="${ltgray}❯${gray}❯${dkgray}❯${reset}  "
  export PS2

  # Prompt when shell script executed in debug mode (set -x) default ="++"
  PS4="${dkgray}$0${yellow}:${LINENO:-} ${black}❯${dkgray}❯${yellow}❯${reset}  "
  export PS4

  #-----------------------------------------------------------------------------
  # LS COLORS
  #-----------------------------------------------------------------------------
  # @see: https://gist.github.com/seantrane/e13706494a54bd3a6c2456608ea68c7e

  # The value of this variable describes what color to use when colors are enabled
  # with `CLICOLOR`.
  export CLICOLOR=1
  # The `LSCOLORS` string is a concatenation of pairs of the format `fb`,
  # where `f` is the foreground color and `b` is the background color.
  #
  # The color designators are as follows:
  #
  # | Code | Description                               |
  # |:----:|:------------------------------------------|
  # | `a`  | black                                     |
  # | `b`  | red                                       |
  # | `c`  | green                                     |
  # | `d`  | brown                                     |
  # | `e`  | blue                                      |
  # | `f`  | magenta                                   |
  # | `g`  | cyan                                      |
  # | `h`  | light grey                                |
  # | `A`  | bold black, usually shows up as dark grey |
  # | `B`  | bold red                                  |
  # | `C`  | bold green                                |
  # | `D`  | bold brown, usually shows up as yellow    |
  # | `E`  | bold blue                                 |
  # | `F`  | bold magenta                              |
  # | `G`  | bold cyan                                 |
  # | `H`  | bold light grey; looks like bright white  |
  # | `x`  | default foreground or background          |
  #
  # Note that the above are standard ANSI colors. The actual display may
  # differ depending on the color capabilities of the terminal in use.

  # The default is `exfxcxdxbxegedabagacad`, i.e. blue foreground and
  # default background for regular directories, black foreground and
  # red background for `setuid` executables, etc.
  # LSCOLORS='exfxcxdxbxegedabagacad'
  # The order of the attributes are as follows:
  _lscolors=(
    'ex' # 01. directory
    'Dx' # 02. symbolic link
    'fx' # 03. socket
    'dx' # 04. pipe
    'cx' # 05. executable
    'da' # 06. block special
    'da' # 07. character special
    'ab' # 08. executable with `setuid` bit set
    'ag' # 09. executable with `setgid` bit set
    'ac' # 10. directory writable to others, with sticky bit
    'ad' # 11. directory writable to others, without sticky bit
  )
  # Merge array into properly formatted string.
  _ogIFS=$IFS
  IFS=''
  export LSCOLORS="${_lscolors[*]}"
  IFS=$_ogIFS

  #-----------------------------------------------------------------------------
  # LS COLORS
  #-----------------------------------------------------------------------------
  #
  # `LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31'`
  #
  # Parameters for `LS_COLORS` (`di`, `fi`, ...) refer to different file types:
  #
  # | Code | Description                                                     |
  # |:----:|:----------------------------------------------------------------|
  # | `no` | No color code at all                                            |
  # | `fi` | Regular file: use no color at all                               |
  # | `rs` | Reset to "normal" color                                         |
  # | `di` | Directory                                                       |
  # | `ln` | Symbolic Link                                                   |
  # | `mh` | MULTIHARDLINK - regular file with more than one link            |
  # | `pi` | Named pipe, Fifo file                                           |
  # | `so` | Socket file                                                     |
  # | `do` | Door file                                                       |
  # | `bd` | Block device driver, (buffered) special file                    |
  # | `cd` | Character device driver, (unbuffered) special file              |
  # | `or` | Orphan symlink to nonexistent file, or non-`stat`'able file     |
  # | `mi` | Non-existent file symlinked (visible when you type `ls -l`)     |
  # | `su` | Normal file that is `setuid` (`u+s`)                            |
  # | `sg` | Normal file that is `setgid` (`g+s`)                            |
  # | `ca` | File with capability (very expensive to lookup)                 |
  # | `tw` | Directory that is sticky and other-writable (`+t`,`o+w`)        |
  # | `ow` | Directory that is other-writable (`o+w`) and not sticky         |
  # | `st` | Directory with the sticky bit set (`+t`) and not other-writable |
  # | `ex` | File which is executable (ie. has `x` set in permissions)       |
  #
  # ### Color Codes
  #
  # |  Code | Description                            |
  # |------:|:---------------------------------------|
  # |   `0` | Default Color                          |
  # |   `1` | Bold                                   |
  # |   `2` | Dim                                    |
  # |   `3` | Italic                                 |
  # |   `4` | Underlined                             |
  # |   `5` | Blinking Text                          |
  # |   `7` | Reverse Text                           |
  # |   `8` | Conceal Text (Hidden)                  |
  # |  `30` | Black                                  |
  # |  `31` | Red                                    |
  # |  `32` | Green                                  |
  # |  `33` | Yellow                                 |
  # |  `34` | Blue                                   |
  # |  `35` | Magenta                                |
  # |  `36` | Cyan                                   |
  # |  `37` | White/Grey                             |
  # |  `39` | Default                                |
  # |  `40` | Black Background                       |
  # |  `41` | Red Background                         |
  # |  `42` | Green Background                       |
  # |  `43` | Yellow Background                      |
  # |  `44` | Blue Background                        |
  # |  `45` | Magenta Background                     |
  # |  `46` | Cyan Background                        |
  # |  `47` | White/Grey Background                  |
  # |  `49` | Default Background                     |
  # |  `90` | Black - High Intensity                 |
  # |  `91` | Red - High Intensity                   |
  # |  `92` | Green - High Intensity                 |
  # |  `93` | Yellow - High Intensity                |
  # |  `94` | Blue - High Intensity                  |
  # |  `95` | Magenta - High Intensity               |
  # |  `96` | Cyan - High Intensity                  |
  # |  `97` | White/Grey - High Intensity            |
  # |  `99` | Default - High Intensity               |
  # | `100` | Black Background - High Intensity      |
  # | `101` | Red Background - High Intensity        |
  # | `102` | Green Background - High Intensity      |
  # | `103` | Yellow Background - High Intensity     |
  # | `104` | Blue Background - High Intensity       |
  # | `105` | Magenta Background - High Intensity    |
  # | `106` | Cyan Background - High Intensity       |
  # | `107` | White/Grey Background - High Intensity |
  # | `109` | Default Background - High Intensity    |
  #
  # These codes can also be combined with one another:
  #     di=5;34;43

  # Reusable color combos
  _ls_audio="35"
  _ls_code="37"
  _ls_exec="01;32"
  _ls_hide="02;30"
  _ls_hush="02;37"
  _ls_image="36"
  _ls_special="33"
  _ls_video="94"
  _ls_zip="03;34"

  # Colorize tree even when used in pipes
  # 'typeset' disabled so that this file can be sourced in both Bash and Zsh.
  # typeset -Tgx LS_COLORS ls_colors ':'
  ls_colors=(
    # Parameters for `LS_COLORS` (`di`, `fi`, ...) refer to different file types:
    'no=00'       # no = No color code at all
    'fi=00'       # fi = Regular file: use no color at all
    'rs=0'        # rs = Reset to "normal" color
    'di=01;34'    # di = Directory
    'ln=03;93'    # ln = Symbolic Link
    'mh=00'       # mh = MULTIHARDLINK - regular file with more than one link
    'pi=40;33'    # pi = Named pipe, Fifo file
    'so=01;35'    # so = Socket file
    'do=01;35'    # do = Door file
    'bd=40;33;01' # bd = Block device driver, (buffered) special file
    'cd=40;33;01' # cd = Character device driver, (unbuffered) special file
    'or=40;31;03' # or = Orphan symlink to nonexistent file, or non-stat'able file
    'mi=00'       # mi = Non-existent file symlinked (visible with `ls -l`)
    'su=37'       # su = Normal file that is `setuid` (`u+s`)
    'sg=30'       # sg = Normal file that is `setgid` (`g+s`)
    'ca=30'       # ca = File with capability (very expensive to lookup)
    'tw=30'       # tw = Directory that's sticky and other-writable (`+t`,`o+w`)
    'ow=01;33'    # ow = Directory that's other-writable (`o+w`), not sticky
    'st=37'       # st = Directory with sticky bit set (`+t`), not other-writable
    'ex=01;32'    # ex = File which is executable (ie. has `x` set in permissions)
    # HIDDEN OS FILES
    "*._*=$_ls_hide"
    "*.CFUserTextEncoding=$_ls_hide"
    "*.DS_Store=$_ls_hide"
    "*.file=$_ls_hide"
    "*.localized=$_ls_hide"
    # HIDDEN IDE/PROJECT FILES
    "*.c9=$_ls_hush"
    "*.cache=$_ls_hush"
    "*.classpath=$_ls_hush"
    "*.dockerignore=$_ls_hush"
    "*.editorconfig=$_ls_hush"
    "*.env=$_ls_hush"
    "*.eslintrc.json=$_ls_hush"
    "*.git=$_ls_hush"
    "*.gitignore=$_ls_hush"
    "*.grunt=$_ls_hush"
    "*.idea=$_ls_hush"
    "*.jekyll-metadata=$_ls_hush"
    "*.launch=$_ls_hush"
    "*.localrc=$_ls_hush"
    "*.lock-wscript=$_ls_hush"
    "*.lock=$_ls_hush"
    "*.log=$_ls_hush"
    "*.markdownlint.json=$_ls_hush"
    "*.mega-linter.yml=$_ls_hush"
    "*.netrc=$_ls_hush"
    "*.prettierrc=$_ls_hush"
    "*.project=$_ls_hush"
    "*.sass-cache=$_ls_hush"
    "*.settings=$_ls_hush"
    "*.sonar=$_ls_hush"
    "*.sublime-*=$_ls_hush"
    "*.swp=$_ls_hush"
    "*.terraform.lock.hcl=$_ls_hush"
    "*.terraform=$_ls_hush"
    "*.vscode=$_ls_hush"
    "*.webpack.json=$_ls_hush"
    # SHELL / TERMINAL / USER
    "*.account=$_ls_hush"
    "*.anyconnect=$_ls_hush"
    "*.bash_env=$_ls_hush"
    "*.bash_history=$_ls_hush"
    "*.bash_login=$_ls_hush"
    "*.bash_profile=$_ls_hush"
    "*.bash_prompt=$_ls_hush"
    "*.bashrc=$_ls_hush"
    "*.curlrc=$_ls_hush"
    "*.gemrc=$_ls_hush"
    "*.hushlogin=$_ls_hush"
    "*.inputrc=$_ls_hush"
    "*.irbrc=$_ls_hush"
    "*.lesshst=$_ls_hush"
    "*.localrc=$_ls_hush"
    "*.npmrc=$_ls_hush"
    "*.profile=$_ls_hush"
    "*.screenrc=$_ls_hush"
    "*.serverlessrc=$_ls_hush"
    "*.sh_history=$_ls_hush"
    "*.vault=token=$_ls_hush"
    "*.viminfo=$_ls_hush"
    "*.vimrc=$_ls_hush"
    "*.wgetrc=$_ls_hush"
    "*.zcompdump=$_ls_hush"
    "*.zhistory=$_ls_hush"
    "*.zlogin=$_ls_hush"
    "*.zlogout=$_ls_hush"
    "*.zpreztorc=$_ls_hush"
    "*.zprofile=$_ls_hush"
    "*.zsh_history=$_ls_hush"
    "*.zshenv=$_ls_hush"
    "*.zshrc=$_ls_hush"
    # GIT / SOURCE CONTROL
    "*.gitattributes=$_ls_hush"
    "*.gitconfig=$_ls_hush"
    "*.gitflow_export=$_ls_hush"
    "*.gitignore_global=$_ls_hush"
    "*.gitignore=$_ls_hush"
    "*.hgignore_global=$_ls_hush"
    "*.hgignore=$_ls_hush"
    # SPECIAL
    "*_config.yml=01;35"
    "*.Brewfile=01;31"
    "*.code-workspace=01;02;$_ls_special"
    "*.env.example=02;03;$_ls_special"
    "*.env=$_ls_special"
    "*.Gemfile=01;31"
    "*.symlink=02;03;$_ls_special"
    "*Brewfile.lock.json=02;03;31"
    "*Brewfile=01;31"
    "*CODEOWNERS=$_ls_special"
    "*CONTRIBUTING.md=$_ls_special"
    "*docker-compose.yml=01;35"
    "*Dockerfile=01;31"
    "*Gemfile.lock=02;03;31"
    "*Gemfile=01;31"
    "*LICENSE=03"
    "*package-lock.json=02;03;35"
    "*package.json=01;35"
    "*README.md=01;04;$_ls_special"
    # SHELL SCRIPTS (non-executable)
    "*.bash=$_ls_special"
    "*.sh=$_ls_special"
    "*.zsh=$_ls_special"
    # EXECUTABLES / COMPILED SOURCE
    "*.app=$_ls_exec"
    "*.bat=$_ls_exec"
    "*.btm=$_ls_exec"
    "*.class=$_ls_exec"
    "*.cmd=$_ls_exec"
    "*.com=$_ls_exec"
    "*.dll=$_ls_exec"
    "*.exe=$_ls_exec"
    "*.o=$_ls_exec"
    "*.so=$_ls_exec"
    # PACKAGES
    "*.deb=$_ls_special"
    "*.dmg=$_ls_special"
    "*.pkg=$_ls_special"
    "*.rpm=$_ls_special"
    # COMPRESSION
    "*.7z=$_ls_zip"
    "*.arj=$_ls_zip"
    "*.bz=$_ls_zip"
    "*.bz2=$_ls_zip"
    "*.gz=$_ls_zip"
    "*.jar=$_ls_zip"
    "*.lzh=$_ls_zip"
    "*.rar=$_ls_zip"
    "*.t7z=$_ls_zip"
    "*.tar=$_ls_zip"
    "*.taz=$_ls_zip"
    "*.tgz=$_ls_zip"
    "*.Z=$_ls_zip"
    "*.z=$_ls_zip"
    "*.zip=$_ls_zip"
    # CODE
    "*.c=$_ls_code"
    "*.cjs=$_ls_code"
    "*.cjsx=$_ls_code"
    "*.cts=$_ls_code"
    "*.ctsx=$_ls_code"
    "*.java=$_ls_code"
    "*.js=$_ls_code"
    "*.jsx=$_ls_code"
    "*.mjs=$_ls_code"
    "*.mjsx=$_ls_code"
    "*.mts=$_ls_code"
    "*.mtsx=$_ls_code"
    "*.php=$_ls_code"
    "*.py=$_ls_code"
    "*.rb=$_ls_code"
    "*.ts=$_ls_code"
    "*.tsx=$_ls_code"
    # PRO IMAGE
    "*.ai=01;$_ls_image"
    "*.indd=01;$_ls_image"
    "*.psd=01;$_ls_image"
    "*.xcf=01;$_ls_image"
    # IMAGE
    "*.bmp=$_ls_image"
    "*.eps=01;$_ls_image"
    "*.gif=$_ls_image"
    "*.icns=$_ls_image"
    "*.ico=$_ls_image"
    "*.jpeg=$_ls_image"
    "*.jpg=$_ls_image"
    "*.pct=$_ls_image"
    "*.pict=$_ls_image"
    "*.png=$_ls_image"
    "*.sgi=$_ls_image"
    "*.svg=$_ls_image"
    "*.svgz=$_ls_image"
    "*.tga=$_ls_image"
    "*.tif=$_ls_image"
    "*.tiff=$_ls_image"
    "*.webp=$_ls_image"
    # PRO AUDIO
    "*.abl=01;95"
    "*.ablbundle=03;$_ls_audio"
    "*.adg=03;$_ls_audio"
    "*.adv=03;$_ls_audio"
    "*.agr=03;$_ls_audio"
    "*.alc=03;$_ls_audio"
    "*.alp=03;$_ls_audio"
    "*.als=03;$_ls_audio"
    "*.ams=03;$_ls_audio"
    "*.amxd=03;$_ls_audio"
    "*.asd=03;$_ls_audio"
    "*.ask=03;$_ls_audio"
    "*.band=01;95"
    "*.logicx=01;95"
    "*.sd2=$_ls_audio"
    "*.sesx=01;$_ls_video"
    # AUDIO
    "*.aac=$_ls_audio"
    "*.aif=$_ls_audio"
    "*.aifc=$_ls_audio"
    "*.aiff=$_ls_audio"
    "*.alac=$_ls_audio"
    "*.au=$_ls_audio"
    "*.caf=$_ls_audio"
    "*.flac=$_ls_audio"
    "*.flc=$_ls_audio"
    "*.m4a=$_ls_audio"
    "*.m4b=$_ls_audio"
    "*.mid=$_ls_audio"
    "*.midi=$_ls_audio"
    "*.mka=$_ls_audio"
    "*.mp3=$_ls_audio"
    "*.mpc=$_ls_audio"
    "*.ogg=$_ls_audio"
    "*.ra=$_ls_audio"
    "*.smf=$_ls_audio"
    "*.wav=$_ls_audio"
    "*.wave=$_ls_audio"
    # PRO VIDEO
    "*.aep=01;$_ls_video"
    "*.m2t=01;$_ls_video"
    "*.prproj=01;$_ls_video"
    # VIDEO
    "*.avi=$_ls_video"
    "*.flv=$_ls_video"
    "*.m4v=$_ls_video"
    "*.mkv=$_ls_video"
    "*.mov=$_ls_video"
    "*.mp4=$_ls_video"
    "*.mpeg=$_ls_video"
    "*.mpg=$_ls_video"
    "*.qt=$_ls_video"
    "*.wmv=$_ls_video"
  )
  # typeset -gx zls_colors=("${ls_colors[@]}")

  _ogIFS=$IFS
  IFS=':'
  export LS_COLORS="${ls_colors[*]}:"
  IFS=$_ogIFS

  #-----------------------------------------------------------------------------
  # ALIASES
  #-----------------------------------------------------------------------------
  # Aliases should only be available to prompt-user (not scripts).

  # `~/.aliases` can be used for private aliases.
  [[ -f "$HOME/.bash_aliases" ]] && . "$HOME/.bash_aliases"

  #-----------------------------------------------------------------------------
  # BASH OPTIONS
  #-----------------------------------------------------------------------------

  # Case-insensitive globbing (used in pathname expansion)
  shopt -s nocaseglob

  # Append to the Bash history file, rather than overwriting it
  shopt -s histappend

  # Autocorrect typos in path names when using `cd`
  shopt -s cdspell

  # Enable some Bash 4 features when possible:
  # * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
  # * Recursive globbing, e.g. `echo **/*.txt`
  for option in autocd globstar; do
    shopt -s "$option" 2>/dev/null
  done

  #-----------------------------------------------------------------------------
  # TAB COMPLETION
  #-----------------------------------------------------------------------------

  # Only if Bash-version is >= 4
  if ! shopt -oq posix && [[ ${BASH_VERSION%%[^0-9]*} -ge 4 ]]; then
    # Add tab completion for many Bash commands
    # Thanks to @tmoitie, adds more tab completion for bash,
    # also when hitting tab twice it will show a list.
    if type "brew" &>/dev/null && [[ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]]; then
      . "$(brew --prefix)/share/bash-completion/bash_completion"
    elif type "brew" &>/dev/null && [[ -f "$(brew --prefix)/share/bash-completion" ]]; then
      . "$(brew --prefix)/share/bash-completion"
    elif [[ -f "/usr/share/bash-completion/bash_completion" ]]; then
      . "/usr/share/bash-completion/bash_completion"
    elif [[ -f "/etc/bash_completion" ]]; then
      . "/etc/bash_completion"
    fi
  fi

  # Tab completion for SSH hostnames, based on ~/.ssh/config, ignoring wildcards
  if [[ -e "$HOME/.ssh/config" ]]; then
    complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh
  fi

  # Enable tab completion for `g` by marking it as an alias for `git`
  if type "_git" &>/dev/null && [[ -f "$(brew --prefix)/etc/bash_completion.d/git-completion.bash" ]]; then
    complete -o default -o nospace -F _git g
  fi

  ##############################################################################
  ##############################################################################
  ##
  ##  2a. LOGIN / .bash_profile / .bash_login
  ##
  ##  This is executed only when it is a login shell.
  ##  Put your `~/.bash_profile` and `~/.bash_login` stuff here.
  ##
  ##############################################################################
  if shopt -q login_shell; then
    : ##########################################################################
    # echo "$SHELL::interactive-login"

    THIS_USER=${USER:-$(id -un || echo "\u")}
    THIS_HOST=${HOST:-${HOSTNAME:-$(hostname || echo "\h")}}
    THIS_SYS=${UTYPE:-${OSTYPE:-$(uname || echo "")}}
    THIS_MACH=${UMACH:-${MACHTYPE:-$(uname -m || echo "")}}
    THIS_ARCH=${UARCH:-${HOSTTYPE:-$(uname -p || echo "")}}

    LOGIN_OUTPUT="${Reset:-}${ClearNewLine:-}"
    LOGIN_OUTPUT+="\n ${Cyan:-}SYSTEM ❯ ${THIS_SYS} ${THIS_MACH} ${THIS_ARCH}"
    LOGIN_OUTPUT+="\n ${Red:-}SHELL  ❯ $(${SHELL:-} --version | head -n 1)"
    LOGIN_OUTPUT+="\n ${Yellow:-}USER   ❯ ${THIS_USER:-} @ ${THIS_HOST} (${LANG:-})"
    LOGIN_OUTPUT+="\n ${Green:-}HOME   ❯ ${HOME:-}"
    LOGIN_OUTPUT+="${Reset:-}"

    echo -e "${LOGIN_OUTPUT}"

  ##############################################################################
  ##############################################################################
  ##
  ##  2b. NON-LOGIN / .bash_profile
  ##
  ##  Only when it is NOT a login shell.
  ##  This is the default `~/.bashrc` environment.
  ##  That means this can be ignored unless considerations
  ##  are required for NON-LOGIN USERS ONLY.
  ##
  ##############################################################################
  else
    : ##########################################################################
  # echo "$SHELL::interactive-nonlogin"

  ##############################################################################
  fi ###########################################################################
##
##  THE END: CONDITIONAL CONFIGURATION
##
fi #############################################################################
################################################################################

export SDKMAN_DIR="/opt/sdkman"
# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
[[ -e "/opt/sdkman/bin/sdkman-init.sh" ]] && source "/opt/sdkman/bin/sdkman-init.sh"
