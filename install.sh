#!/usr/bin/env bash

ARGS=`getopt -o nfh --long dry-run,force,help -n $(basename "${0}") -- "$@"`
eval set -- "${ARGS}"
unset ARGS

DRY_RUN=0
FORCE=0
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

usage() {
    cat <<USAGE
Usage: ${0} [OPTION]...
Install the dotfiles in your environment.

The options are:
    -h, --help          Display this help and exit
    -n, --dry-run       Do not execute the commands, only log the actions via the logger
    -f, --force         Force the creation of the symbolic links

USAGE
}

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

        if [ "${file_path}" == "." ]; then
            file_path=""
        fi

        declare local file_name=$(basename $file)
        declare local source_file_path="${ROOT_PATH}/${file}"
        declare local target_directory="${HOME}"

        if [ "${file_path}" != "" ]; then
            target_directory="${target_directory}/${file_path}"
        fi

        if [ ! -d "${target_directory}" ]; then
            log "The path ${target_directory} does not exist"
            run "mkdir -p ${target_directory}"
        fi

        declare local target_path="${target_directory}/${file_name}"
        declare local create_link_cmd="ln -sf ${source_file_path} ${target_path}"

        if [ -f "${target_path}" ]; then
            declare local force="n"

            if [ "${FORCE}" -eq 1 ]; then
                run "${create_link_cmd}"
            else
                declare local force_create=$(ask "The file ${target_path} already exists. Do you want to force the creation of the link? [Y/n]" "Y")

                if [[ "${force_create}" =~ [Yy] ]]; then
                    run "${create_link_cmd}"
                fi
            fi
        else
            run "${create_link_cmd}"
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

while true; do
    case "${1}" in
        -n|--dry-run)
            log "Dry-run mode enabled"
            DRY_RUN=1
            shift
            ;;
        -f|--force)
            log "Force mode enabled"
            FORCE=1
            shift
            ;;
        -h|--help)
            log "Usage"
            usage
            exit 0
            ;;
        --)
            shift
            break
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

create_links
install_vim_env

exit 0

