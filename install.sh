#!/bin/bash

CWD=`pwd`

# vim
function configure_vim() {
    if command -v vim > /dev/null 2>&1; then
        # Install pathogen if not installed yet.
        local AUTOLOAD_DIR=$HOME/.vim/autoload/
        local BUNDLE_DIR=$HOME/.vim/bundle
        if [ ! -f $AUTOLOAD_DIR/pathogen.vim ]; then
            # Check if curl is installed.
            which curl > /dev/null
            if [ "$?" == "0" ]; then
                mkdir -p $AUTOLOAD_DIR $BUNDLE_DIR && \
                curl -LSso $AUTOLOAD_DIR/pathogen.vim https://tpo.pe/pathogen.vim
            else
                echo "Error: curl is not installed"
            fi
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

        # Install vim-code-dark
        if [ ! -d $BUNDLE_DIR/vim-code-dark ]; then
            (cd $BUNDLE_DIR && git clone https://github.com/tomasiser/vim-code-dark.git)
        else
            echo vim-code-dark is already installed
        fi

        # Install vim-fugitive
        if [ ! -d $BUNDLE_DIR/vim-fugitive ]; then
            (cd $BUNDLE_DIR && git clone https://github.com/tpope/vim-fugitive.git && vim -u NONE -c "helptags vim-fugitive/doc" -c q)
        else
            echo vim-fugitive is already installed
        fi

        # Install indentLine
        if [ ! -d $BUNDLE_DIR/indentline ]; then
            (cd $BUNDLE_DIR && git clone https://github.com/Yggdroot/indentLine.git)
        else
            echo indentLine is already installed
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
        echo "vim is not installed, skipping vim configuration & plugins ..."
    fi
}

# gitconfig
function configure_git() {
    local GITCONFIG="$HOME/.gitconfig"

    if [ -e $GITCONFIG ]; then
        if [ -e $GITCONFIG.bkp ]; then
            echo overriding previous .gitconfig backup file
        fi
        mv $GITCONFIG $GITCONFIG.bkp
    fi

    echo copying git config file ...
    cp $CWD/gitconfig $GITCONFIG
}

# PS1
function format_ps1() {
    if [ -z $BASHRC ]; then
        local BASHRC=""
        if [ -f $HOME/.bashrc ]; then
            BASHRC="$HOME/.bashrc"
        elif [ -f $HOME/.profile ]; then
            BASHRC="$HOME/.profile"
        fi
    fi

    if [ -e $BASHRC ]; then

        local CONFIGURED="false"
        local LEN_BASHRC=`cat $BASHRC | wc -l`
        local LEN_PS1=`cat $CWD/PS1 | wc -l`

        if [ $LEN_BASHRC -gt $LEN_PS1 ]; then
            local MAX=$(($LEN_BASHRC-$LEN_PS1+2))
            i=1; while [ "$i" -lt $MAX ]; do
                j=$(($i+$LEN_PS1-1))
                if [ $(sed -n "${i},${j}p" $BASHRC | diff $CWD/PS1 - | wc -l) -ne 0 ]; then
                    i=$((i+1))
                else
                    CONFIGURED="true"
                    i=$MAX
                fi
            done
        fi

        if [ "$CONFIGURED" = "false" ]; then
            echo configuring $BASHRC ...
            cat $CWD/PS1 >> $BASHRC
        else
            echo PS1 is already configured
        fi
    else
        echo "ERROR: cannot find bashrc file in $BASHRC"
        exit 1
    fi
}

function usage() {
    echo "Usage: $0 [option/s] ";
    echo "";
    echo "options:";
    echo "--configure-git   Install ~/.gitconfig from our gitconfig file";
    echo "--format-ps1      Append PS1 file content to ~/.bashrc if not done yet.";
    echo "--configure-vim   Install ~/.vimrc from our vimrc file and install plugins.";
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

