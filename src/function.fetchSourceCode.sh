#!/usr/bin/env bash

fetchSourceCode() {
    local sSourceRepo sTargetPath

    readonly sTargetPath="${1?Two parameters required: <target-path> <repository-name>}"
    readonly sSourceRepo="${1?Two parameters required: <target-path> <source-repository>}"

    git clone "${sSourceRepo}" "${sTargetPath}"

    rm -rdf "${sTargetPath}/.git"
}
