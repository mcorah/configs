#!/bin/bash
set -x

DIR=$( dirname ${BASH_SOURCE[0]} )
ln -s ${DIR}/vimrc ~/.vimrc
ln -s ${DIR}/bashrc ~/.bashrc
ln -s ${DIR}/xmonad.hs ~/.xmonad/
