#!/bin/bash

# !!!!!  RUN THIS INSIDE THE CONTAINER !!!!!!


XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-~/.config}
dry="0"

while [[ $# > 0 ]]; do
    if [[ $1 == "--dry" ]]; then
        dry="1"
    fi
    shift
done

#install the dooms
install_doom() {

    execute git clone https://github.com/doomemacs/doomemacs ~/.emacs.d
    execute ~/.emacs.d/bin/doom install
    execute ~/.emacs.d/bin/doom sync

}

log() {

    if [[ $dry == "1" ]]; then
      echo "[DRY_RUN]: $@"
    else
        echo $@
    fi

}

execute() {
    log "execute $@"
    if [[ $dry == "1" ]]; then
        return
    fi
    "$@"
}

log "------------------------ dev-env ------------------------"

copy_dir() {
    from=$1
    to=$2
    pushd $from > /dev/null
    dirs=$(find . -mindepth 1 -maxdepth 1 -type d)
    for dir in $dirs; do
        execute rm -fr $to/$dir
        execute cp -r $dir $to/$dir
    done
    popd > /dev/null
}

copy_file() {
    from=$1
    to=$2
    name=$(basename $from)
    execute rm  $to/$name
    execute cp $name $to/$name

}

echo "copying dotfiles...."
copy_dir .config $XDG_CONFIG_HOME
copy_file .bashrc $HOME

echo "installing languages and runtimes. go, rust, deno"
#should we check if it's installed already or does mise do that?
execute mise install golang@latest
execute mise install rust@latest
execute mise install deno@latest

execute mise use golang@latest
execute mise use rust@latest
execute mise use deno@latest

echo "Do you want to install DOOM Emacs now? type Y or N"
read wants_doom

wants_doom=$(echo "$wants_doom" | tr '[:upper:]' '[:lower:]')
if [[ "$wants_doom" == "y" ]]; then
    install_doom
    echo "DOOM Emacs installed! Sweet"
else
    echo "Skipping Doom install. Emacs is installed but with vanilla configuration"
fi



echo "Dev Env is ready to roll!"
