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

    # Emoji Commit Legend
    #
    # | Commit              | Emoji  |                         |
    # | ------------------- | -----: | :---------------------: |
    # | Documentation       |     📚 | :books:                 |
    # | Configuration files |     🔧 | :wrench:                |
    # | CI build system     |     👷 | :construction_worker:   |
    # | Funding related     |     💰 | :moneybag:              |
    #
    # Source: https://gist.github.com/parmentf/035de27d6ed1dce0b36a
    commitChanges() {
        local sTargetPath

        readonly sTargetPath="${1?One parameter required: <target-path>}"

        git -C "${sTargetPath}" commit --allow-empty --message '🎉'

        git -C "${sTargetPath}" add .gitignore app/.gitkeep
        git -C "${sTargetPath}" commit --message "🔧 Add git ignore"

        git -C "${sTargetPath}" add LICENSE
        git -C "${sTargetPath}" commit --message "📚 Add Licence"

        git -C "${sTargetPath}" add .gitlab-ci.yml .mdlrc .yamllint renovate.json
        git -C "${sTargetPath}" commit --message "👷 Add build system"

        git -C "${sTargetPath}" add .github/FUNDING.yml
        git -C "${sTargetPath}" commit --message "💰 Add funding configuration"

        git -C "${sTargetPath}" add action.yml
        git -C "${sTargetPath}" commit --message "💰 Add funding configuration"
    }

    createLocalRepo() {
        local sRepoName sTargetPath

        readonly sTargetPath="${1?Two parameters required: <target-path> <repository-name>}"
        readonly sRepoName="${1?Two parameters required: <target-path> <repository-name>}"

        git -C "${sTargetPath}" init
        git -C "${sTargetPath}" remote add origin "git@gitlab.com:pipeline-components/${sRepoName}.git"
    }

    fetchSourceCode() {
        local sSourceRepo sTargetPath

        readonly sTargetPath="${1?Two parameters required: <target-path> <repository-name>}"
        readonly sSourceRepo="${1?Two parameters required: <target-path> <source-repository>}"

        git clone "${sSourceRepo}" "${sTargetPath}"

        rm -rdf "${sTargetPath}/.git"
    }

    log() {
        echo -e "\n =====> ${*}"
    }

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

    # If the remote repo does not exist, GitLab will create the repo
    pushChanges() {
        local sTargetPath

        readonly sTargetPath="${1?One parameter required: <target-path>}"

        git -C "${sTargetPath}" push --set-upstream origin master
    }

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

    # Displays all lines in main script that start with '##'
    usage() {
        grep '^#/' <"$0" | cut -c4-
    }

    if [[ $# -lt 1 ]]; then
        echo "$(basename "$0") <target-path> <package-name> [source-repo]"
        echo
        echo "Call $(basename "$0") --help for more details"
        exit 1
    fi

    for sOption in "${@}"; do
        case "${sOption}" in
            -h | --help)
                usage
                return 0
                ;;
        esac
    done

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
