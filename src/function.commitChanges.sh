#!/usr/bin/env bash

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
