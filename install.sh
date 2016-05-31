#!/bin/bash

CWD=`pwd`

# vim
function configure_vim {
    if command -v vim > /dev/null 2>&1; then
        # Install pathogen if not installed yet.
        local AUTOLOAD_DIR=$HOME/.vim/autoload/
        local BUNDLE_DIR=$HOME/.vim/bundle
        if [ ! -f $AUTOLOAD_DIR/pathogen.vim ]; then
            mkdir -p $AUTOLOAD_DIR $BUNDLE_DIR && \
            curl -LSso $AUTOLOAD_DIR/pathogen.vim https://tpo.pe/pathogen.vim
        else
            echo Pathogen is already installed.
        fi

        # Install NERDTree
        if [ ! -d $BUNDLE_DIR/nerdtree ]; then
            (cd $BUNDLE_DIR && git clone https://github.com/scrooloose/nerdtree.git)
        else
            echo nerdtree already installed
        fi

        # Install ctrlp
        if [ ! -d $BUNDLE_DIR/ctrlp.vim ]; then
            (cd $BUNDLE_DIR && git clone https://github.com/kien/ctrlp.vim)
        else
            echo ctrlp already installed
        fi

        # Install vimrc file
        local VIMRC=$HOME/.vimrc
        if [ -e $VIMRC ]; then
            if [ -e $VIMRC.bkp ]; then
                echo overriding previous .vimrc backup file
            fi
            mv $VIMRC $VIMRC.bkp
        fi
        cp $CWD/vimrc $VIMRC

    else
        echo "vim is not installed, skipping vim configuration & plugins" ...
    fi
}

# gitconfig
function configure_git {
    local GITCONFIG="$HOME/.gitconfig"

    if [ -e $GITCONFIG ]; then
        if [ -e $GITCONFIG.bkp ]; then
            echo overriding previous .gitconfig backup file
        fi
        mv $GITCONFIG $GITCONFIG.bkp
    fi
    cp $CWD/gitconfig $GITCONFIG
}

# PS1
function format_ps1 {
    if [ -z $BASHRC ]; then
        BASHRC="$HOME/.bashrc"
    fi

    if [ -e $BASHRC ]; then
        # Get total number of lines to append to .bashrc to check whether we have already modified it.
        local N_LINES=$(cat $CWD/PS1 | wc -l)

        DIFFERENT=$(tail -$N_LINES $BASHRC | diff $CWD/PS1 - | wc -l)
        if [ $DIFFERENT -ne 0 ]; then
            # Then PS1 has not been configured yet.
            # FIXME: if user appends something else to this file, previous command won't work!

            cat $CWD/PS1 >> $BASHRC
        else
            echo PS1 is already configured
        fi
    else
        echo "ERROR: cannot find bashrc file in $BASHRC"
        exit 1
    fi
}

function usage {
    echo "Usage: $0 [option/s] ";
    echo "";
    echo "options:";
    echo "--configure-git   Install ~/.gitconfig from our gitconfig file";
    echo "--format-ps1      Append PS1 file content to ~/.bashrc if not done yet.";
    echo "--configure-vim   Install ~/.vimrc from our vimrc file and install pathogen, NERDTree and ctrlp.";
    echo "--help            Display this message and exit.";
    echo "";
    exit 1;
}

# If we don't select an action, we default to "do everything".
if [ "$#" -ne 0 ]; then
    for arg in "$@"; do
        shift
        case "$arg" in
            "--configure-git")  configure_git; ;;
            "--format-ps1")     format_ps1; ;;
            "--configure-vim")  configure_vim; ;;
            "--help")           usage; exit 1 ;;
            *)                  echo ERROR: wrong argument; usage; exit 1 ;;
        esac
    done
else
    configure_git
    format_ps1
    configure_vim
fi


