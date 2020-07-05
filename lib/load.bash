#!/usr/bin/env bash
#Including Guard
if [[ 1 == "${GW_LIB:-0}" ]]; then
    return
else
    readonly GW_LIB=1
fi
GW_DEBUG="${GW_DEBUG:-0}"
if ((GW_DEBUG == 1)); then
    set -x
fi

#shellcheck source=/dev/null
source "$(dirname "${BASH_SOURCE[0]}")/logging.sh"
#shellcheck source=/dev/null
source "$(dirname "${BASH_SOURCE[0]}")/file.sh"
#shellcheck source=/dev/null
source "$(dirname "${BASH_SOURCE[0]}")/gradle.sh"

#Print a stacktrace when errors encountered
gw::sys::__errorCallBack__() {
  gw::log::err "CallStack:"
  local frame=0
  while caller ${frame}; do
    ((frame++))
  done
  exit 1
}
trap 'gw::sys::__errorCallBack__' ERR

