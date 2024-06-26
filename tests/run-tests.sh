#!/bin/bash
# Copyright 2022 VMware, Inc.
# SPDX-License-Identifier: Apache 2.0

# This set of tests must be run in a clean environment
# It can either be run in docker or   github actions

. $HOME/.asdf/asdf.sh

[[ -z ${DEBUGX:-} ]] || set -x
set -euo pipefail

sep=" "
[[ -z ${ASDF_LEGACY:-} ]] || sep="-"

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
repo_dir="$script_dir/.."

function checkBinaryArch() {
  local plugin_name=$1
  local wanted_arch=$(a=$(uname -m) && ([ $a = aarch64 ] || [ $a = arm64 ]) && printf arm64 || printf x86)

  # Add below the plugins that install the proper architecture.
  case $plugin_name in
  tanzu):
    echo -e "\nChecking $plugin_name is of arch $wanted_arch"
    file $(asdf which "$plugin_name") | grep $wanted_arch
    ;;
  esac
}

function test_plugin() {
  local plugin_name=$1

  echo -e "\n#########################################"
  echo -e "####### Starting: ${plugin_name}\n"

  . "${script_dir}/../products.inc.sh" "${plugin_name}"

  echo "Adding plugin $plugin_name"
  rm -rf "${HOME}/.asdf/plugins/${plugin_name}"
  mkdir -p "${HOME}/.asdf/plugins/${plugin_name}"
  cp -r "$repo_dir" "${HOME}/.asdf/plugins/${plugin_name}"

  echo "Listing $plugin_name"
  asdf list${sep}all "$plugin_name"

  if [[ -z "${ASDF_LEGACY:-}" ]]; then
    echo "Installing $plugin_name"
    asdf install "$plugin_name" latest
  else
    plugin_version="$(asdf list${sep}all $plugin_name |tail -1)"
    echo "Installing $plugin_name" "$plugin_version"
    asdf install "$plugin_name" "$plugin_version"
  fi

  installed_version="$(asdf list $plugin_name | xargs)"
  asdf global "$plugin_name" "$installed_version"

  if [[ $VERSION_COMMAND != "test_not_possible" ]]; then
    echo -e "\nChecking $plugin_name is executable"
    echo "Running command '$plugin_name $VERSION_COMMAND'"
    "$plugin_name" "$VERSION_COMMAND"
  fi

  checkBinaryArch $plugin_name

  echo -e "\n####### Finished: $plugin_name"
  echo -e "#########################################\n"
}

function test_plugins() {
  plugin_name="${1:-}"
  if [ -z "${plugin_name:-}" ]; then
    test_plugin tanzu
    test_plugin kp
    test_plugin uaa-cli
    test_plugin om
    test_plugin pivnet
    test_plugin bosh
    test_plugin credhub
    test_plugin fly
    test_plugin bbr
    test_plugin bbr-s3-config-validator
  else
    test_plugin "$plugin_name"
  fi
}

test_plugins "${1:-}"
