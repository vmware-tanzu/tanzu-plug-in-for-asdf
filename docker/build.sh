#!/bin/bash
# Copyright 2022 VMware, Inc.
# SPDX-License-Identifier: Apache 2.0

set -eu

[ -z "${1:-}" ] && echo 'The tag must be passed in as a arguement. E.g. build.sh v2' && exit 1

readonly tag="$1"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

docker build $script_dir \
  -t "projects.registry.vmware.com/tanzu_plugin_for_asdf_test/asdf_test:${tag}"

docker login projects.registry.vmware.com

docker push "projects.registry.vmware.com/tanzu_plugin_for_asdf_test/asdf_test:${tag}"

