#!/bin/bash
# Copyright 2022 VMware, Inc.
# SPDX-License-Identifier: Apache 2.0

# This set of tests must be run in a clean environment
# It can either be run in docker of github actions

set -ex

[[ -z "${DEBUGX:-}" ]] || set -x

if [[ -z "${ASDF_LEGACY:-}" ]]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf
  cd "$HOME/.asdf"
  latest_tag=$(git describe --abbrev=0)
  git checkout "$latest_tag"
  sep=" "
else
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.6.3
  sep="-"
fi

. "$HOME/.asdf/asdf.sh"
asdf plugin${sep}add kubectl

set +e
asdf_info="$(asdf info)"
echo "$asdf_info"