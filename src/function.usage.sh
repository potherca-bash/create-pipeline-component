#!/usr/bin/env bash

# Displays all lines in main script that start with '##'
usage() {
    grep '^#/' < "$0" | cut -c4-
}
