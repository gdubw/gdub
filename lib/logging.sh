#!/usr/bin/env bash
readonly GW_LOG_DEBUG_LEVEL=10
readonly GW_LOG_INFO_LEVEL=20
readonly GW_LOG_WARN_LEVEL=30
readonly GW_LOG_ERROR_LEVEL=40
readonly GW_LOG_NONE_LEVEL=100
#By default, output nothing
GW_LOG_LEVEL=${GW_LOG_LEVEL:-${GW_LOG_ERROR_LEVEL}}

function gw::__log__() {
    local level="${1-:GW_LOG_INFO_LEVEL}"
    shift
    if ((level < GW_LOG_LEVEL)); then
        return
    fi

    local level_str
    case "${level}" in
    "${GW_LOG_DEBUG_LEVEL}")
        level_str="DEBUG"
        ;;
    "${GW_LOG_INFO_LEVEL}")
        level_str="INFO"
        ;;
    "${GW_LOG_WARN_LEVEL}")
        level_str="WARN"
        ;;
    "${GW_LOG_ERROR_LEVEL}")
        level_str="ERROR"
        ;;
    esac
    echo -e "[Gdub][${level_str}]" "$@"
    shift
}

function gw::log::err() {
    gw::__log__ ${GW_LOG_ERROR_LEVEL} "$@"
}

function gw::log::warn() {
    gw::__log__ ${GW_LOG_WARN_LEVEL} "$@"
}

function gw::log::warn() {
    gw::__log__ ${GW_LOG_WARN_LEVEL} "$@"
}

function gw::log::info() {
    gw::__log__ ${GW_LOG_INFO_LEVEL} "$@"
}

function gw::log::debug() {
    gw::__log__ ${GW_LOG_DEBUG_LEVEL} "$@"
}
