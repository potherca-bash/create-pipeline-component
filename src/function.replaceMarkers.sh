#!/usr/bin/env bash

replaceMarkers() {
    local sPackageName sRepoName sTargetPath

    readonly sTargetPath="${1?Three parameters required: <target-path> <repository-name> <package-name>}"
    readonly sRepoName="${2?Three parameters required: <target-path> <repository-name> <package-name>}"
    readonly sPackageName="${3?Three parameters required: <target-path> <repository-name> <package-name>}"

    sed -i \
      -e "s/_Template_/${sPackageName}/g" \
      -e "s/_template_/${sRepoName}/g" \
      "${sTargetPath}/action.yml" \
      "${sTargetPath}/Dockerfile" \
      "${sTargetPath}/README.md"

    sed -i -e "s/2021/$(date +%Y)/g" "${sTargetPath}/LICENSE" "${sTargetPath}/README.md"
}
