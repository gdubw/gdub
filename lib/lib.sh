#!/usr/bin/env bash
readonly GW_COLOR_RED="\\033[1;31m"
readonly GW_COLOR_YELLOW="\\033[1;33m"
readonly GW_COLOR_WHITE="\\033[0;39m"
readonly GW_NO_COLOR='\033[0m'

readonly GW_LOG_OUTPUT=${GW_LOG_OUTPUT:-/dev/stdout}
readonly GW_LOG_NONE_LEVEL=0
readonly GW_LOG_DEBUG_LEVEL=10
readonly GW_LOG_INFO_LEVEL=20

readonly GW_LOG_LEVEL=${GW_LOG_LEVEL:-0}

function gw::log() {
    local level="${1:-INFO}"
    shift

}
