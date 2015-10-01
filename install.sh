#!/bin/bash
set -x

DIR=$( dirname ${BASH_SOURCE[0]} )
cp ${DIR}/vimrc ~/.vimrc
cp ${DIR}/bashrc ~/.bashrc
cp ${DIR}/xmonad.hs ~/.xmonad/
