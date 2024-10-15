#!/usr/bin/env bash

# Setup environment for tests to run (must run before anything else)
# Arguments:
#   - name of the current container template being tested (e.g. `sap-cap-javascript-node`)
#   - image tag (will replace `${templateOption:imageVariant}`, e.g. `22-bookworm`)
setup() {
  # Set input variables
  IMAGE=$1
  IMAGE_TAG=$2

  PASSED_TESTS=0
  FAILED_TESTS=0

  ID_LABEL="devcontainer-test=$IMAGE"

  SRC_DIR=$(dirname "$0")
  TEST_ROOT=/tmp/devcontainer-templates
  TEST_DIR=$TEST_ROOT/$IMAGE

  # Setup an empty test directory, ensuring test root directory exists
  mkdir -p $TEST_ROOT || true
  rm -rf "$TEST_DIR"

  # Copy devcontainer sources and test scripts/data to the temporary directory
  cp -R "$SRC_DIR"/../../src/"$IMAGE" $TEST_ROOT/
  cp -R "$SRC_DIR"/../../test/"$IMAGE" $TEST_ROOT/

  # Ensure the temporary directory is writable by the container
  chmod -R 755 $TEST_ROOT

  # Replace the image tag from the template options. This is necessary as there is no --build-arg
  # parameter on the devcontainer build command available.
  # A "supporting tool" (e.g. VS Code) would normally do this as part of the interactive installation
  sed -i -e "s/\${templateOption:imageVariant}/${IMAGE_TAG}/g" "$TEST_DIR"/.devcontainer/devcontainer.json

  # Start the devcontainer
  npx devcontainer up --workspace-folder "$TEST_DIR" --id-label "$ID_LABEL"
}

# Run test and evaluate result
# Arguments:
#   - test description
#   - command to be executed
#   - expected result
run_test() {
  local description=$1
  local cmd=$2
  local expected_result=$3

  local result
  # `devcontainer exec` gives its _own_ output on stdout, with the actual output of the command run
  # on stderr. In theory, we could validate that the exec output includes `{"outcome": "success"}`,
  # but if we get the expected output from the exec'd command back that's good enough anyway.
  # Also as this script is set to abort on error, make sure we continue running even if the exit
  # code of the in-container execution is non-zero.
  #
  # We _want_ $cmd to be split here as it could include arguments:
  # shellcheck disable=SC2086
  result=$(npx devcontainer exec --workspace-folder "$TEST_DIR" --id-label "$ID_LABEL" $cmd || true)

  case "$result" in
    *$expected_result*)
      echo "✅ [PASS] $description"
      PASSED_TESTS=$((PASSED_TESTS + 1))
      ;;
    *)
      echo "❌ [FAIL] $description"
      echo "  Expected output of '$cmd' to contain '$expected_result', but got '$result'"
      FAILED_TESTS=$((FAILED_TESTS + 1))
      ;;
  esac
}

# Cleanup after success or failure
cleanup() {
  # Get rid of container if running
  CONTAINER=$(docker container ls -f "label=${ID_LABEL}" -q)
  [[ -z "$CONTAINER" ]] || docker rm -f "$CONTAINER" > /dev/null

  # Remove test directory
  rm -rf "$TEST_DIR"
}
cleanup_from_error_or_interrupt() {
  cleanup
  exit 1
}
trap "cleanup_from_error_or_interrupt" ERR SIGINT

# Print results, clean up, and return an appropriate exit code when the script finishes
end_tests() {
  # Cleanup and print test output
  cleanup
  echo "Passed test(s): $PASSED_TESTS, failed test(s): $FAILED_TESTS"

  # Succeed if there are no failed tests, but also make sure that at least one test has passed
  # (otherwise something else might have gone wrong)
  [ "$FAILED_TESTS" -eq 0 ] && [ "$PASSED_TESTS" -gt 0 ]
}
trap "end_tests" EXIT