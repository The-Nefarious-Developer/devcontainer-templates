#!/usr/bin/env bash
set -euo pipefail
# shellcheck disable=SC1091
source "$(dirname "$0")/../test-utils/harness.sh"

# setup "sap-cap-typescript-node" "22-bookworm"
setup "sap-cap-typescript-node" "$VARIANT"

run_test "Node version is correct" "node -v" "${IMAGE_TAG:0:2}"
run_test "NPM is present" "npm --help" "npm <command>"
run_test "CloudFoundry CLI is present" "cf --version" "cf version 8"
run_test "CAP Development Toolkit is present" "cds version" "@cap-js/asyncapi"
run_test "Typescript is present" "tsc -v" "Version"
run_test "ts-node is present is present" "ts-node -v" "v"
run_test "CAP Typescript Plugin is present" "cds-tsx" ""
run_test "Container defaults to non-root user" "whoami" "node"
run_test "Non-root user is able to sudo" "sudo whoami" "root"