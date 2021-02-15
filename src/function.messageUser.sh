#!/usr/bin/env bash

messageUser() {
    local aEditFiles sFile sTargetPath

    readonly sTargetPath="${1?One parameter required: <target-path>}"

    readonly -a aEditFiles=(
      '.github/workflows/release.yml'
      'Dockerfile'
      'README.md'
    )

    echo "Please edit the following files:"

    for sFile in "${aEditFiles[@]}"; do
      echo -e "\t- ${sTargetPath}/${sFile}"
    done

    echo "and git commit & push them when you are satisfied with your changes."
}
