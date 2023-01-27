#!/usr/bin/env bash
# Copyright 2022 VMware, Inc.
# SPDX-License-Identifier: Apache 2.0

[[ "${BASH_SOURCE[0]}" != "${0}" ]] || {
  echo "${BASH_SOURCE[0]} should not be called but only sourced." >&2
  exit 1
}

setEnv() {
  local product="${1:-}"
  local v="${2:-}"
  local o="${3:-}"

  # To add a product create a case statement matching the file name and add variables as follows
  # REPO_SLUG
  # is the user/repository as taken from the github URL
  # e.g the part in caps: https://github.com/CONCOURSE/CONCOURSE

  # PRIMARY_GIT_TEMPLATE
  # the release file link template
  # e.g what appears after the trailing slash: https://github.com/${github_repo_path}/releases/download/
  # For v7.0.0/fly-7.0.0-linux-amd64.tgz would be v${version}/fly-${version}-${os}-amd64.tgz

  # SECONDARY_GIT_TEMPLATE
  # added as a fall back in case naming standard changes as happened with om 7.8

  # VERSION_COMMAND
  # is the arguement for the command to display the version

  case "${product}" in
    bbr)
      REPO_SLUG='cloudfoundry-incubator/bosh-backup-and-restore'
      PRIMARY_GIT_TEMPLATE="v${v}/bbr-${v}-${o}-amd64"
      SECONDARY_GIT_TEMPLATE=""
      VERSION_COMMAND='--version'
      ;;
    bbr-s3-config-validator)
      REPO_SLUG='cloudfoundry-incubator/bosh-backup-and-restore'
      PRIMARY_GIT_TEMPLATE="v${v}/bbr-s3-config-validator-${v}-${o}-amd64"
      SECONDARY_GIT_TEMPLATE=""
      VERSION_COMMAND='--help'
      ;;
    bosh)
      REPO_SLUG='cloudfoundry/bosh-cli'
      PRIMARY_GIT_TEMPLATE="v${v}/bosh-cli-${v}-${o}-amd64"
      SECONDARY_GIT_TEMPLATE=""
      VERSION_COMMAND='--version'
      ;;
    credhub)
      REPO_SLUG='cloudfoundry-incubator/credhub-cli'
      PRIMARY_GIT_TEMPLATE="${v}/credhub-${o}-${v}.tgz"
      SECONDARY_GIT_TEMPLATE=""
      VERSION_COMMAND='--version'
      ;;
    fly)
      REPO_SLUG='concourse/concourse'
      PRIMARY_GIT_TEMPLATE="v${v}/fly-${v}-${o}-amd64.tgz"
      SECONDARY_GIT_TEMPLATE=""
      VERSION_COMMAND='--version'
      ;;
    kpack-cli)
      REPO_SLUG='vmware-tanzu/kpack-cli'
      PRIMARY_GIT_TEMPLATE="v${v}/kp-${o}-amd64-${v}"
      SECONDARY_GIT_TEMPLATE="v${v}/kp-${o}-${v}"
      VERSION_COMMAND='version'
      ;;
    om)
      REPO_SLUG='pivotal-cf/om'
      PRIMARY_GIT_TEMPLATE="${v}/om-${o}-amd64-${v}"
      SECONDARY_GIT_TEMPLATE="${v}/om-${o}-${v}"
      VERSION_COMMAND='--version'
      ;;
    pivnet)
      REPO_SLUG='pivotal-cf/pivnet-cli'
      PRIMARY_GIT_TEMPLATE="v${v}/pivnet-${o}-amd64-${v}"
      SECONDARY_GIT_TEMPLATE=""
      VERSION_COMMAND='version'
      ;;
    uaa-cli)
      REPO_SLUG='cloudfoundry/uaa-cli'
      PRIMARY_GIT_TEMPLATE="${v}/uaa-${o}-amd64-${v}"
      SECONDARY_GIT_TEMPLATE=""
      VERSION_COMMAND='version'
      ;;
    *)
      echo "Product '${product}' is not currently supported" >&2
      return 2
      ;;
  esac
  
  # MISSING_PRODUCTS is used to highlight products that aren't available for an OS type
  MISSING_PRODUCTS=(
    "bbr-s3-config-validator_darwin"
  )

  declare -rx REPO_SLUG GIT_FILE_NAME_TEMPLATE VERSION_COMMAND
}

setEnv "$@"
