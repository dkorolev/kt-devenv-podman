#!/bin/bash
#
# Just `./devenv.sh` will start the dev environment.
#
# Alternatively, some `./devenv.sh -c 'gradle run'` runs a specific command.
# Be sure to `rm .devenv_podman_container_id` when altering the container.

set +e

CONTAINER_FN=.devenv_podman_container_id

if [ -f "$CONTAINER_FN" ] ; then
  CANDIDATE_CONTAINER_ID="$(cat "$CONTAINER_FN")"
  if ! podman image inspect "$CANDIDATE_CONTAINER_ID" >/dev/null 2>&1 ; then
    echo 'The image provided in `'$CONTAINER_FN'` is not available. Rebuilding.'
  else
    CONTAINER_ID="$CANDIDATE_CONTAINER_ID"
  fi
fi

if [ "$CONTAINER_ID" == "" ] ; then
  DOCKER_BUILDKIT=1 podman build .
  CONTAINER_ID=$(DOCKER_BUILDKIT=1 podman build -q .)
  echo $CONTAINER_ID >"$CONTAINER_FN"
fi

INTERACTIVE_FLAG=$([ -t 0 ] && echo '-it' || echo '-i')

podman run -v "$PWD":/work $INTERACTIVE_FLAG $CONTAINER_ID "$@"
