#!/bin/bash

# DEFAULTS
GRADLEW='gradlew'
GRADLE_BUILDFILE='build.gradle'
DEFAULT_BUILDFILE="${HOME}/.gradle/default/${GRADLE_BUILDFILE}"
GW_ARGS=${@}

function echo_error() {
  echo "${@}" >&2
}

function lookup() {
  local file=${1}
  local curr_path=${2}
  [[ -z "${curr_path}" ]] && curr_path=${PWD}

  # Search recursively upwards for file.
  until [[ "${curr_path}" == "/" ]]; do
    if [[ -e "${curr_path}/${file}" ]]; then
      echo "${curr_path}/${file}"
      break
    else 
      curr_path=$(dirname "${curr_path}")
    fi
  done
}

function select_gradle() {
  local dir=${1}
  local gradle=$(lookup ${GRADLEW} ${dir})

  # Deal with a missing wrapper by defaulting to system gradle.
  if [[ -z "${gradle}" ]]; then
    gradle=$(which gradle)
    echo_error "There is no ${GRADLEW} set up for this project. You may want to consider setting one up."
    echo_error "See: http://gradle.org/docs/current/userguide/gradle_wrapper.html"
  fi

  # Check that we have an executable gradle, and error out if not.
  if [[ -x ${gradle} ]];  then
    echo ${gradle}
  else
    echo_error "Unable to find an executable ${GRADLEW} or 'gradle' is not installed and available on your path."
    exit 1
  fi
}

function execute_gradle() {
  local build_gradle=$(lookup ${GRADLE_BUILDFILE})

  if [[ -z "${build_gradle}" ]]; then
    # No gradle buildfile, so set up gw to run the default one.
    build_gradle=${DEFAULT_BUILDFILE}
    gradle=$(select_gradle $(dirname ${DEFAULT_BUILDFILE}))
    GW_ARGS="-b ${build_gradle} ${GW_ARGS}"
  else
    # We got a good build file, start there.
    working_dir=$(dirname ${build_gradle})
    gradle=$(select_gradle ${working_dir})
    cd ${working_dir}
  fi

  # Say what we are gonna do, then do it.
  echo -e "Using gradle at '${gradle}' to run '${build_gradle}':\n"
  "${gradle}" ${GW_ARGS}
}

execute_gradle