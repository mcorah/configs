# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

PS1='${debian_chroot:+($debian_chroot)}\n\[\033[03;91m\][ \[\033[03;34m\]\u@\h\[\033[00m\] \[\033[03;91m\]: \[\033[03;34m\]\w\[\033[00m\] \[\033[03;91m\]]\n\n\[\033[03;91m\]\$\[\033[00m\] '
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
  xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
  *)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  . /etc/bash_completion
fi

export EDITOR="vim"

#my machine specific bash configs
if [ -f ~/.bash_specific ]; then
    . ~/.bash_specific
fi

alias sgrep='grep --exclude-dir=.svn --exclude=*~ -r'
alias julia='OPENBLAS_NUM_THREADS=4 julia'

function freplace() { find ./ -type f -exec sed -i -e "s|$1|$2|g" {} \; ;}

function ipaddress
{
  CONNECTION=wlan0
  if [ $# -eq 1 ]; then
    CONNECTION=$1
  fi

  ifconfig $CONNECTION | grep "inet " | awk -F'[: ]+' '{ print $4 }'
}

function show_var()
{
  for i in $@; do
    echo "$i=${!i}"
  done
}

# ROS and RASL related
function compile_wet_sandbox
{
  CWD=`pwd`;
  cd ~/sandbox/$1/wet;
  if (( "$#" == 1 )); then
    CMD="catkin_make --cmake-args -DCMAKE_BUILD_TYPE=Release"
    echo ${CMD}
    eval ${CMD}
  elif (( "$#" == 2 )); then
    CMD="catkin_make --pkg ${2} --cmake-args -DCMAKE_BUILD_TYPE=Release"
    echo ${CMD}
    eval ${CMD}
  fi
  cd ${CWD};
}
alias csw='compile_wet_sandbox'

export SANDBOX_FILE=~/.sandbox
function set_sandbox
{
  if (( "$#" == 1 )); then
    WORKON_FILE=~/sandbox/${1}/workon
    if [ -f $WORKON_FILE ]; then
      echo "Setting $1 as current sandbox"
      echo ". $WORKON_FILE" > $SANDBOX_FILE
      source $SANDBOX_FILE
    else
      echo "ERROR: sandbox ~/sandbox/${1} does not exist, not changing workspace"
    fi
  else
    if [ -f $SANDBOX_FILE ]; then
      rm $SANDBOX_FILE
    fi

    if [ -n ${ROS_BASE_ENV+x} ]; then
      source $ROS_BASE_ENV
    else
      echo "NO BASE ROS ENVIRONMENT SET"
    fi
  fi
  # ROS_PACKAGE_PATH effectively provides a summary of loaded workspaces
  # although a large number of variables are loaded including variables such as
  # PATH and LD_LIBRARY_PATH
  show_var ROS_PACKAGE_PATH
}
alias sbox="set_sandbox"

if [ -f $SANDBOX_FILE ]; then
  source $SANDBOX_FILE
fi

function ros_remote
{
  export ROS_MASTER_URI="http://${1}:11311"
}

function set_ros_ip
{
  CONNECTION=wlan0
  if [ $# -eq 1 ]; then
    CONNECTION=$1
  fi

  export ROS_IP=$( ipaddress $CONNECTION )
  echo $ROS_IP
}
alias rosip="set_ros_ip"

function setup_ros_base
{
  CONNECTION=wlan0
  if [ $# -eq 1 ]; then
    CONNECTION=$1
  fi
  rosip $CONNECTION

  ros_remote $ROS_IP
}
alias sbase="setup_ros_base"

function ssh_quad
{
  ssh quad@${1}
}
alias ssh_quad="sshq"

function logdiff
{
  A=HEAD
  B=$1
  if (( $# == 2)); then
    A=$1
    B=$2
  fi
   git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s
   %Cgreen(%cr)%Creset' --abbrev-commit --date=relative $A..$B
}

function scan
{
  dev=wlan0
  if (( $# == 1)); then
    dev=$1
  fi
  echo "Scanning $dev"
  sudo arp-scan --interface=$dev --localnet
}

function avconvert
{
  if (( $# == 1)); then
    filename=$1
    extension="${filename##*.}"
    namestring="${filename%.*}"
    avconv -i $filename "${namestring}_avconv.mp4"
  fi
}


# run catkin tests and grep for output
function catkin_gtest
{
  catkin build  --catkin-make-args run_tests && \
  # greps output for Google red, green, or yellow
  # See: https://github.com/google/googletest/blob/master/googletest/src/gtest.cc
  catkin run_tests | command grep -E $(printf '\033\\[0;31m|\033\\[0;32m|\033\\[0;33m') && \
  catkin_test_results
}
