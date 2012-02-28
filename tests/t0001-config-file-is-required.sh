#!/bin/sh
#
# Anchovy connects to the database using the settings in migrations/config

. test-lib.sh

# create an empty directory somewhere which is treated as our 'project'
# directory for the scope of this test
create_project_dir
# create an empty migrations directory
mkdir migrations

# run the anchovy script and expect it to fail
set +e
stdout=$($anchovy_cmd 2>&1)
exit_status=$?
set -e

# assertions
assert_equals 1 "$exit_status" "Expected an unsuccesful exit status"
expected_message="ERROR: Configuration 'migrations/config' not found.
Please add the configuration file named 'config' to the migrations directory"
assert_equals "$expected_message" "$stdout" "Did not receive the expected error message"
