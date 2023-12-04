#!/bin/bash

# stolen from Donald (ddn0); this symlinks everything in this
# directory to the actual locations used by the system

BASE=$(cd "$(dirname $0)"; pwd)

# update functions create directory then force overwrite symlink
# overwriting may be dangerous in some settings (e.g. some
# systems have a bashrc that loads important things); need to create
# copy of existing one
# TODO check for existence so no annoying errors  occur
case `uname` in
  Darwin*)
    function update() {
      if [[ -n "$(dirname $2)" ]]; then
        mkdir -p "$(dirname $2)"
      fi
      # make a backup
			cp $2 ${2}_old
      ln -s -F -h $1 $2
    }
    ;;
  *)
    function update() {
      if [[ -n "$(dirname $2)" ]]; then
        mkdir -p "$(dirname $2)"
      fi
      # make a backup
			cp $2 ${2}_old
      ln -s --force --no-dereference $1 $2
    }
esac

update $BASE/bashrc $HOME/.bashrc
update $BASE/config/coc-settings.json $HOME/.vim/coc-settings.json
update $BASE/inputrc $HOME/.inputrc
update $BASE/vimrc $HOME/.vimrc
update $BASE/gitconfig $HOME/.gitconfig
update $BASE/tmux.conf $HOME/.tmux.conf

tmux source ~/.tmux.conf
