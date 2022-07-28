#!/usr/bin/env bash

# Dependency: requires gh (https://github.com/cli/cli)

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open a GitHub repo
# @raycast.author Tony Abboud
# @raycast.authorURL https://github.com/tabboud
# @raycast.description Open a GitHub Repo using org/repo notation
# @raycast.argument1 { "type": "text", "placeholder": "org/repo" }
# @raycast.argument2 { "type": "text", "placeholder": "gh-enterprise", "optional", "true" }

# Optional parameters:
# @raycast.mode silent

if ! command -v gh &>/dev/null; then
    echo "Github CLI (gh) is required (https://github.com/cli/cli)"
    exit 1
fi

if [[ -z "$1" ]]; then
    echo "org/repo is required"
    exit 1
fi

HOST="github.com"
if [[ -n "$2" ]]; then
    if [[ -z "${GHE_ORG}" ]]; then
        echo "The GHE_ORG env var was empty but must be set to open a GHE repo"
        exit 1
    fi
    HOST="${GHE_ORG}"
fi

env GH_HOST="${HOST}" gh repo view --web "$1"
