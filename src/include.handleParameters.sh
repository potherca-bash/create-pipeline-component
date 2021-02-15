#!/usr/bin/env bash

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
