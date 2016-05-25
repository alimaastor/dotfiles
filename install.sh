#!/bin/sh

CWD=`pwd`

# copy the gitconfig file.
GITCONFIG="$HOME/.gitconfig"
if [ -e $GITCONFIG ]; then
    mv $GITCONFIG $GITCONFIG.bkp
fi

cp $CWD/gitconfig $GITCONFIG

# set the PS1 variable.
if [ -z $BASHRC ]; then
    BASHRC="$HOME/.bashrc"
fi

if [ -e $BASHRC ]; then
    cat $CWD/PS1 >> $BASHRC
else
    echo "ERROR: cannot find bashrc file in $BASHRC"
    exit 1
fi

