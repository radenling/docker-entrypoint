#!/bin/sh

set -e

run_scripts () {
  local directory=$1; shift
  if [ -d "$directory" -a -n "$(ls -A "$directory")" ]; then
    local last_file=$(echo "${directory}"/* | sed 's/.* \(.*\)$/\1/')
    for f in "${directory}"/*; do
      if [ -f "$f" ]; then
        if [ "$last_file" = "$f" ]; then
          exec sh "$f"
        else
          sh "$f"
        fi
      fi
    done
  fi
}

# Set defaults
: ${ENTRYPOINT_DIR:=/entrypoint.d}

: ${CONTAINER_USER:=container}
: ${CONTAINER_GROUP:=container}
: ${CONTAINER_UID:=8000}
: ${CONTAINER_GID:=8000}
: ${CONTAINER_HOME:=$(pwd)}
: ${CONTAINER_COMMAND:=$@}

# These should be available to the init scripts
export CONTAINER_USER CONTAINER_GROUP
export CONTAINER_UID CONTAINER_GID
export CONTAINER_HOME CONTAINER_COMMAND

run_scripts "$ENTRYPOINT_DIR"
