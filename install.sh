#!/usr/bin/env bash

DRY_RUN=${DRY_RUN:-0}
ROOT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
VIM_RUNTIME_PATH="${HOME}/.vim"
BG_PATH=".config/wallpaper/bg.jpg"

which logger >> /dev/null

if [ "${?}" -eq 0 ]; then
    LOGGER="logger -t dotfiles"
else
    LOGGER="echo"
fi

declare -a FILES_TO_LINK=(
    .vimrc
    .Xresources
    .vim_runtime/my_configs.vim
    .config/bg.sh
    .config/compton.conf
    .config/dunst/dunstrc
    .config/i3/config
    .config/polybar/config
    .config/polybar/launch.sh
    .screenlayout/config.sh
    .screenlayout/hotplug.sh
)

declare -a VIM_PLUGINS=(
   https://github.com/scrooloose/nerdtree 
)

log() {
    eval "${LOGGER} '${1}'"
}

run() {
    log "${1}"

    if [ "${DRY_RUN}" -eq 0 ]; then
        eval ${1}
    fi
}

ask() {
    declare local question=${1}
    declare local default_answer=${2:-""}
    declare local answer=""

    read -p "${question} " answer

    if [ "${answer}" == "" ]; then
        answer=${default_answer}
    fi

    echo "${answer}"
}

create_links() {
    for file in "${FILES_TO_LINK[@]}"; do
        declare local file_path=$(dirname $file)
        declare local file_name=$(basename $file)
        declare local source_file_path="${ROOT_PATH}/${file}"
        declare local target_directory="${HOME}/${file_path}"
        declare local target_path="${target_directory}/${file_name}"

        if [ "${file_path}" != "." ]; then
            if [ ! -d "${target_directory}" ]; then
                log "The path ${target_directory} does not exist"
                run "mkdir -p ${target_directory}"
            fi

            if [ -f "${target_path}" ]; then
                force=$(ask "The file ${target_path} already exists. Do you want to force the creation of the link? [Y/n]" "Y")

                if [ "${force}" == "Y" ]; then
                    run "ln -sf ${source_file_path} ${target_path}"
                fi
            fi
        fi
    done

    if [ ! -f "${HOME}/${BG_PATH}" ]; then
        log "Install the default wallpaper"
        run "ln -s ${ROOT_PATH}/$BG_PATH} ${HOME}/${BG_PATH}"
    fi
}

install_vim_env() {
    declare local vim_plugins_path="${VIM_RUNTIME_PATH}/pack/plugins/start"
    log "Create the directory ${vim_plugins_path} if it does not exist"
    run "mkdir -p ${vim_plugins_path}"
    run "cd ${vim_plugins_path}"

    for plugin in "${VIM_PLUGINS[@]}"; do
        log "Cloning the repository ${plugin}"
        run "git clone ${plugin} &> /dev/null"
    done
}

create_links
install_vim_env

exit 0

