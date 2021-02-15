#!/usr/bin/env bash

createLocalRepo() {
    local sRepoName sTargetPath

    readonly sTargetPath="${1?Two parameters required: <target-path> <repository-name>}"
    readonly sRepoName="${1?Two parameters required: <target-path> <repository-name>}"

    git -C "${sTargetPath}" init
    git -C "${sTargetPath}" remote add origin "git@gitlab.com:pipeline-components/${sRepoName}.git"
}
