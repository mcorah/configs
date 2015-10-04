#!/bin/bash
set -x

DIR=$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd )
ln -s ${DIR}/vimrc ~/.vimrc
ln -s ${DIR}/bashrc ~/.bashrc
ln -s ${DIR}/xmonad.hs ~/.xmonad/xmonad.hs
