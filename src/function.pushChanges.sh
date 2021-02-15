#!/usr/bin/env bash

# If the remote repo does not exist, GitLab will create the repo
pushChanges() {
    local sTargetPath

    readonly sTargetPath="${1?One parameter required: <target-path>}"

    git -C "${sTargetPath}" push --set-upstream origin master
}
