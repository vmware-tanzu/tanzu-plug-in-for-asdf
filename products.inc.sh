#!/usr/bin/env bash
# Copyright 2022 VMware, Inc.
# SPDX-License-Identifier: Apache 2.0

[[ "${BASH_SOURCE[0]}" != "${0}" ]] || {
  echo "${BASH_SOURCE[0]} should not be called but only sourced." >&2
  exit 1
}

version_greater_equal_than() {
  local minimum_version="$1"
  local current_version="${v#v}"
  local version_regex='^([0-9]+)\.([0-9]+)\.([0-9]+)(-.*)?$'

  [[ "${current_version}" =~ ${version_regex} ]] || return 1
  local current_major="${BASH_REMATCH[1]}"
  local current_minor="${BASH_REMATCH[2]}"
  local current_patch="${BASH_REMATCH[3]}"
  local current_prerelease="${BASH_REMATCH[4]:-}"

  [[ "${minimum_version}" =~ ${version_regex} ]] || return 1
  local minimum_major="${BASH_REMATCH[1]}"
  local minimum_minor="${BASH_REMATCH[2]}"
  local minimum_patch="${BASH_REMATCH[3]}"
  local minimum_prerelease="${BASH_REMATCH[4]:-}"

  if (( current_major != minimum_major )); then
    (( current_major > minimum_major ))
  elif (( current_minor != minimum_minor )); then
    (( current_minor > minimum_minor ))
  elif (( current_patch != minimum_patch )); then
    (( current_patch > minimum_patch ))
  elif [[ -n "${current_prerelease}" && -z "${minimum_prerelease}" ]]; then
    return 1
  elif [[ -z "${current_prerelease}" && -n "${minimum_prerelease}" ]]; then
    return 0
  else
    [[ "${current_prerelease}" == "${minimum_prerelease}" ]]
  fi
}

setEnv() {
  local product="${1:-}"
  local v="${2:-}"
  local o="${3:-}"
  local a="${4:-}"

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

      if [[ "${o}" == "darwin" || "${o}" == "linux" ]] && version_greater_equal_than 1.9.50; then
        PRIMARY_GIT_TEMPLATE="v${v}/bbr-${v}-${o}-${a}"
      fi
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

      if { [[ "${o}" == "darwin" ]] && version_greater_equal_than 6.4.9; } || { [[ "${o}" == "linux" ]] && version_greater_equal_than 7.2.3; }; then
        PRIMARY_GIT_TEMPLATE="v${v}/bosh-cli-${v}-${o}-${a}"
      fi
      ;;
    credhub)
      REPO_SLUG='cloudfoundry/credhub-cli'
      PRIMARY_GIT_TEMPLATE="${v}/credhub-${o}-amd64-${v}.tgz"
      SECONDARY_GIT_TEMPLATE="${v}/credhub-${o}-${v}.tgz"
      VERSION_COMMAND='--version'

      if [[ "${o}" == "darwin" ]] && version_greater_equal_than 2.9.21; then
        PRIMARY_GIT_TEMPLATE="${v}/credhub-${o}-${a}-${v}.tgz"
      fi
      ;;
    fly)
      REPO_SLUG='concourse/concourse'
      PRIMARY_GIT_TEMPLATE="v${v}/fly-${v}-${o}-amd64.tgz"
      SECONDARY_GIT_TEMPLATE=""
      VERSION_COMMAND='--version'

      if [[ "${o}" == "darwin" || "${o}" == "linux" ]] && version_greater_equal_than 7.14.0; then
        PRIMARY_GIT_TEMPLATE="v${v}/fly-${v}-${o}-${a}.tgz"
      fi
      ;;
    kp)
      REPO_SLUG='vmware-tanzu/kpack-cli'
      PRIMARY_GIT_TEMPLATE="v${v}/kp-${o}-amd64-${v}"
      SECONDARY_GIT_TEMPLATE="v${v}/kp-${o}-${v}"
      VERSION_COMMAND='version'

      if { [[ "${o}" == "darwin" ]] && version_greater_equal_than 0.7.1; } || { [[ "${o}" == "linux" ]] && version_greater_equal_than 0.9.1; }; then
        PRIMARY_GIT_TEMPLATE="v${v}/kp-${o}-${a}-${v}"
      fi
      ;;
    om)
      REPO_SLUG='pivotal-cf/om'
      PRIMARY_GIT_TEMPLATE="${v}/om-${o}-amd64-${v}"
      SECONDARY_GIT_TEMPLATE="${v}/om-${o}-${v}"
      VERSION_COMMAND='--version'

      if [[ "${o}" == "darwin" || "${o}" == "linux" ]] && version_greater_equal_than 7.8.0; then
        PRIMARY_GIT_TEMPLATE="${v}/om-${o}-${a}-${v}"
      fi
      ;;
    pivnet)
      REPO_SLUG='pivotal-cf/pivnet-cli'
      PRIMARY_GIT_TEMPLATE="v${v}/pivnet-${o}-amd64-${v}"
      SECONDARY_GIT_TEMPLATE=""
      VERSION_COMMAND='version'

      if [[ "${o}" == "darwin" ]] && version_greater_equal_than 4.1.1; then
        PRIMARY_GIT_TEMPLATE="v${v}/pivnet-${o}-${a}-${v}"
      fi
      ;;
    tanzu)
      # Tanzu CLI only started supporting ARM64 natively for darwin with version 1.1.0*
      # we therefore use the AMD64 version for older versions
      REPO_SLUG='vmware-tanzu/tanzu-cli'
      PRIMARY_GIT_TEMPLATE="v${v}/tanzu-cli-${o}-amd64.tar.gz"
      SECONDARY_GIT_TEMPLATE=""
      VERSION_COMMAND='version' #| grep version | sed -n -e "s/^.*version: v//p"

      if [[ "${o}" == "darwin" ]] && version_greater_equal_than 1.1.0; then
        PRIMARY_GIT_TEMPLATE="v${v}/tanzu-cli-${o}-${a}.tar.gz"
      fi
      ;;
    uaa-cli)
      REPO_SLUG='cloudfoundry/uaa-cli'
      PRIMARY_GIT_TEMPLATE="${v}/uaa-${o}-amd64-${v}"
      SECONDARY_GIT_TEMPLATE=""
      VERSION_COMMAND='version'

      if { [[ "${o}" == "darwin" ]] && version_greater_equal_than 0.11.0; } || { [[ "${o}" == "linux" ]] && version_greater_equal_than 0.20.0; }; then
        PRIMARY_GIT_TEMPLATE="${v}/uaa-${o}-${a}-${v}"
      fi
      ;;
    *)
      echo "Product '${product}' is not currently supported" >&2
      return 2
      ;;
  esac


  # MISSING_PRODUCTS is used to highlight products that aren't available for an OS_ARCH type
  MISSING_PRODUCTS=(
    "bbr-s3-config-validator_darwin_amd64"
    "bbr-s3-config-validator_darwin_arm64"
    "tanzu_linux_arm64"
  )

  declare -rx REPO_SLUG GIT_FILE_NAME_TEMPLATE VERSION_COMMAND
}

setEnv "$@"
