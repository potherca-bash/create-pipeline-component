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

# Displays all lines in main script that start with '##'
usage() {
  grep '^#/' < "$0" | cut -c4-
}

run() {
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
    log 'Committing changes'

    git_dir "${sTargetPath}" commit --allow-empty --message '🎉'

    git_dir "${sTargetPath}" add .gitignore app/.gitkeep
    git_dir "${sTargetPath}" commit --message "🔧 Add git ignore"

    git_dir "${sTargetPath}" add LICENSE
    git_dir "${sTargetPath}" commit --message "📚 Add Licence"

    git_dir "${sTargetPath}" add .gitlab-ci.yml .mdlrc .yamllint renovate.json
    git_dir "${sTargetPath}" commit --message "👷 Add build system"

    git_dir "${sTargetPath}" add .github/FUNDING.yml
    git_dir "${sTargetPath}" commit --message "💰 Add funding configuration"

    git_dir "${sTargetPath}" add action.yml
    git_dir "${sTargetPath}" commit --message "💰 Add funding configuration"
  }

  createLocalRepo() {
    log 'Creating local repository'

    git_dir "${sTargetPath}" init
    git_dir "${sTargetPath}" remote add origin "git@gitlab.com:pipeline-components/${sRepoName}.git"
  }

  fetchSourceCode() {
    log 'Fetching source code'

    git clone "${sSourceRepo}" "${sTargetPath}"

    rm -rdf "${sTargetPath}/.git"
  }

  git_dir() {
    local -a aParameters=(
      "--work-tree=${1}"
      "--git-dir=${1}/.git"
    )

    shift

    aParameters=("${aParameters[@]}" "${@}")

    git "${aParameters[@]}"
  }

  log () {
    echo -e "\n =====> ${*}"
  }

  messageUser() {
    local aEditFiles sFile

    log 'Done'

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
    log 'Pushing changes'

    git_dir "${sTargetPath}" push --set-upstream origin master
  }

  replaceMarkers() {
    log 'Replacing markers'

    sed -i \
      -e "s/_Template_/${sPackageName}/g" \
      -e "s/_template_/${sRepoName}/g" \
      "${sTargetPath}/action.yml" \
      "${sTargetPath}/Dockerfile" \
      "${sTargetPath}/README.md"

    sed -i -e "s/2020/$(date +%Y)/g" "${sTargetPath}/LICENSE" "${sTargetPath}/README.md"
  }

  #  if [[ $(git reflog | wc -l) -eq 1 ]] ; then
  #  fi

  fetchSourceCode
  replaceMarkers
  createLocalRepo
  commitChanges
  pushChanges
  messageUser
}

if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
  export -f run
else
  run "${@}"
fi
