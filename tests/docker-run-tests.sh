#!/bin/bash
# Copyright 2022 VMware, Inc.
# SPDX-License-Identifier: Apache 2.0

[[ -z ${DEBUGX:-} ]] || set -x
set -uo pipefail

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker_img='projects.registry.vmware.com/tanzu_plugin_for_asdf_test/asdf_test:v1'
docker_cmd='./tests/setup-env.sh && ./tests/run-tests.sh "$@"'
docker_args=(
  --rm
  --volume "${script_dir}/../:/workspace"
  --env DEBUGX="${DEBUGX:-}"
  --env GITHUB_API_TOKEN
  --env DOCKER_MODE=true
  --workdir /workspace
)

docker run "${docker_args[@]}" "${docker_img}" bash -c "${docker_cmd}" -- "$@"

return_code=$?
if [[ $return_code -ne 0 ]]; then
  exit $return_code
fi

docker_args+=( --env ASDF_LEGACY=true )
docker run "${docker_args[@]}" "${docker_img}" bash -c "${docker_cmd}" -- "$@"

echo "Latest exit code: $?"
