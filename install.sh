#!/usr/bin/env bash

DEBUG=${DEBUG:-0}
ROOT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"

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
    .config/wallpaper/bg.jpg
    .screenlayout/config.sh
    .screenlayout/hotplug.sh
)

function debug {
    if [ "${DEBUG}" -eq 1 ]; then
        echo "debug: ${1}"
    fi
}

function run {
    if [ "${DEBUG}" -eq 1 ]; then
        debug "${1}"
    else
        eval ${1}
    fi
}

for file in " ${FILES_TO_LINK[@]}"
do
    declare local file_path=$(dirname $file)
    declare local file_name=$(basename $file)
    declare local source_file_path="${ROOT_PATH}/${file}"
    declare local target_directory="${HOME}/${file_path}"
    declare local target_path="${target_directory}/${file_name}"

    if [ "${file_path}" != "." ]; then
        debug "Check if the path ${target_directory} exists"

        if [ ! -d "${target_directory}" ]; then
            debug "The path does not exist"
            run "mkdir -p ${target_directory}"
        fi

        run "ln -sf ${source_file_path} ${target_path}"
    fi
done

