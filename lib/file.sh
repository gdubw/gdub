#!/usr/bin/env bash
function gw::file::abs() {
    local path="$1"
    [ -e "${path}" ] || {
        echo "${path}"
        return 1
    }
    if [ -d "$path" ]; then
        local abs_path_dir
        abs_path_dir="$(cd "$path" && pwd)"
        echo "${abs_path_dir}"
    else
        local file_name
        local abs_path_dir
        file_name="$(basename "$path")"
        path=$(dirname "$path")
        abs_path_dir="$(cd "$path" && pwd)"
        echo "${abs_path_dir}/${file_name}"
    fi
}

function gw::file::lookup() {
    local file="${1}"
    local curr_path="${2}"
    [[ -z "${curr_path}" ]] && curr_path="${PWD}"

    [[ -e "${curr_path}" ]] || {
        gw::log::err "${curr_path} doesn't exist."
        return 1
    }

    # Search recursively upwards for file.
    until [[ "${curr_path}" == "/" ]]; do
        if [[ -e "${curr_path}/${file}" ]]; then
            echo "${curr_path}/${file}"
            return 0
        else
            curr_path=$(dirname "${curr_path}")
        fi
    done
    return 1
}
