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

declare -A BINARIES=(
    ["bin/open-ranger"]="/usr/local/bin/open-ranger"
)

usage() {
    cat <<USAGE
Usage: ${0} [OPTION]...
Install the dotfiles in your environment.

The options are:
    -h, --help          Display this help and exit
    -n, --dry-run       Do not execute the commands, only log the actions
    -f, --force         Force the creation of the symbolic links

USAGE
}

_log() {
    eval "${LOGGER} '${1}'"
}

_run() {
    _log "${1}"

    if [ "${DRY_RUN}" -eq 0 ]; then
        eval ${1}
    fi
}

_ask() {
    declare local question=${1}
    declare local default_answer=${2:-""}
    declare local answer=""

    read -p "${question} " answer

    if [ "${answer}" == "" ]; then
        answer=${default_answer}
    fi

    echo "${answer}"
}

_build_file_path() {
    declare local file_path=$(dirname ${1})

    if [ "${file_path}" == "." ]; then
        file_path=""
    fi

    echo $file_path
}

_build_source_file_path() {
    echo "${ROOT_PATH}/${1}"
}

_build_target_directory() {
    declare local file_path=$(_build_file_path ${1})
    declare local target_directory=${HOME}

    if [ "${file_path}" != "" ]; then
        target_directory="${target_directory}/${file_path}"
    fi

    echo ${target_directory}
}

_check_directory() {
    local target_directory=${1}

    if [ ! -d "${target_directory}" ]; then
        _log "The path ${target_directory} does not exist"
        _run "mkdir -p ${target_directory}"
    fi
}

_link() {
    declare local source_path=${1}
    declare local target_path=${2}
    declare local use_sudo=${3:-0}
    declare local create_link_cmd=""

    if [ "${use_sudo}" -eq 1 ]; then
        create_link_cmd="sudo "
    fi

    create_link_cmd="${create_link_cmd}ln -sf ${source_path} ${target_path}"

    if [ -f "${target_path}" ]; then
        declare local force="n"

        if [ "${FORCE}" -eq 1 ]; then
            _run "${create_link_cmd}"
        else
            declare local force_create=$(_ask "The file ${target_path} already exists. Do you want to force the creation of the link? [Y/n]" "Y")

            if [[ "${force_create}" =~ [Yy] ]]; then
                _run "${create_link_cmd}"
            fi
        fi
    else
        _run "${create_link_cmd}"
    fi
}

create_links() {
    for file in "${FILES_TO_LINK[@]}"; do
        declare local file_name=$(basename ${file})
        declare local source_file_path=$(_build_source_file_path ${file})
        declare local target_directory=$(_build_target_directory ${file})

        _check_directory ${target_directory}
        _link "${source_file_path}" "${target_directory}/${file_name}"
    done

    if [ ! -f "${HOME}/${BG_PATH}" ]; then
        _log "Install the default wallpaper"
        _run "ln -s ${ROOT_PATH}/$BG_PATH} ${HOME}/${BG_PATH}"
    fi

    for binary in "${!BINARIES[@]}"; do
        declare local source_file_path=$(_build_source_file_path ${binary})
        _link "${source_file_path}" "${BINARIES[${binary}]}" 1
    done
}

install_vim_env() {
    declare local vim_plugins_path="${VIM_RUNTIME_PATH}/pack/plugins/start"
    _log "Create the directory ${vim_plugins_path} if it does not exist"
    _run "mkdir -p ${vim_plugins_path}"
    _run "cd ${vim_plugins_path}"

    for plugin in "${VIM_PLUGINS[@]}"; do
        _log "Cloning the repository ${plugin}"
        _run "git clone ${plugin} &> /dev/null"
    done
}

while true; do
    case "${1}" in
        -n|--dry-_run)
            _log "Dry-run mode enabled"
            DRY_RUN=1
            shift
            ;;
        -f|--force)
            _log "Force mode enabled"
            FORCE=1
            shift
            ;;
        -h|--help)
            _log "Usage"
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

