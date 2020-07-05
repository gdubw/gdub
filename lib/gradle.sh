#!/usr/bin/env bash

# DEFAULTS may be overridden by calling environment.
readonly GRADLE="${GRADLE:-gradle}"
readonly GRADLEW="${GRADLEW:-gradlew}"
readonly GRADLE_BUILDFILE="${GRADLE_BUILDFILE:-build.gradle}"
readonly GRADLE_KTS_BUILDFILE="${GRADLE_KTS_BUILDFILE:-build.gradle.kts}"
readonly GLOBAL_GRADLE="${GLOBAL_GRADLE:-0}"

function gw::select_gradle() {
    local dir="${1}"

    # Use project's gradlew if found.
    local gradlew
    gradlew=$(gw::file::lookup "${GRADLEW}" "${dir}")
    if [[ $? -ne 0 ]]; then
        gw::log::err "No ${GRADLEW} set up for this project; consider setting one up using 'gng --bootstrap'"
        return 1
    else
        echo "${gradlew}"
        return 0
    fi
    (( GLOBAL_GRADLE == 0 )) && {
        gw::log::err "No ${GRADLEW} set up for this project; consider setting one up using 'gng --bootstrap'"
        return 1
    }

    # Deal with a missing wrapper by defaulting to system gradle.
    local gradle
    gradle=$(which "${GRADLE}" 2>/dev/null)
    if [[ $? -ne 0 ]]; then
        gw::log::err "'${GRADLE}' not installed or not available in your PATH:"
        gw::log::err "${PATH}"
        return 1
    else
        echo "${gradle}"
        return 0
    fi
    return 1
}