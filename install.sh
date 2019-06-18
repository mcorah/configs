#!/bin/bash

# back up files if necessary but only if not linking
function testandlink
{
  SOURCE=$1
  DEST=$2

  # check existence
  if [ -e "$DEST" ] ; then
    # if it exists, check if it is a symlink and to the source
    if ! [ -L "$DEST" ] ; then
      echo "Backing up ${DEST}"

      cp $DEST ${DEST}.bac
    fi
  fi

  echo "linking $SOURCE to $DEST"
  ln -sf $SOURCE $DEST
}

DIR=$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd )
testandlink ${DIR}/vimrc           ~/.vimrc
testandlink ${DIR}/vimrc           ~/.config/nvim/init.vim
testandlink ${DIR}/bashrc          ~/.bashrc
testandlink ${DIR}/xmonad.hs       ~/.xmonad/xmonad.hs
testandlink ${DIR}/juliarc.jl      ~/.juliarc.jl
testandlink ${DIR}/mygitcheck.py   ~/mygitcheck.py
testandlink ${DIR}/clang-format    ~/.clang-format
testandlink ${DIR}/setup_conda.env ~/setup_conda.env
