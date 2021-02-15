#!/usr/bin/env bash

set -o errexit -o errtrace -o nounset -o pipefail

#/==============================================================================
#/                         CREATE PIPELINE COMPONENT REPO
#/------------------------------------------------------------------------------
#/ This script will create a boilerplate repository for a new Pipeline Component
#/ and push it to Pipeline Components on GitLab. If the remote repository does
#/ not yet exist, it will be created as a private project.
#/
#/ Usage:
#/
#/     create_component <target-path> <package-name> [source-repo]
#/
#/ Where:
#/
#/    <target-path>   Is the path where the repo should be created. This should
#/                    include the name of the component
#/    <package-name>  The human readable name of the component
#/    [source-repo]   The skeleton repository that should be used as source
#/
#/ Usage example:
#/
#/     create_component ./xmllint 'XML Lint'
#/===============================================================================

run() {
    source src/function.commitChanges.sh
    source src/function.createLocalRepo.sh
    source src/function.fetchSourceCode.sh
    source src/function.log.sh
    source src/function.messageUser.sh
    source src/function.pushChanges.sh
    source src/function.replaceMarkers.sh
    source src/function.usage.sh

    source src/include.handleParameters.sh

    local sPackageName sSourceRepo sRepoName sTargetPath

    readonly sTargetPath="${1?Two parameters required: <target-path> <package-name> [source-repo]}"
    readonly sPackageName="${2?Two parameters required: <target-path> <package-name> [source-repo]}"
    readonly sSourceRepo="${3:-git@gitlab.com:pipeline-components/org/skeleton.git}"

    readonly sRepoName="$(basename "${sTargetPath}")"

    log 'Fetching source code'
    fetchSourceCode "${sTargetPath}" "${sSourceRepo}"
    log 'Replacing markers'
    replaceMarkers "${sTargetPath}" "${sRepoName}" "${sPackageName}"
    log 'Creating local repository'
    createLocalRepo "${sTargetPath}" "${sRepoName}"
    log 'Committing changes'
    commitChanges "${sTargetPath}"
    log 'Pushing changes'
    pushChanges "${sTargetPath}"
    log 'Done.'
    messageUser "${sTargetPath}"
}

if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
  export -f run
else
  run "${@}"
fi
