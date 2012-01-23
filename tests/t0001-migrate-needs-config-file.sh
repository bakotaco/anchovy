#!/bin/sh
#
# Migrate connects to the database using the settings in migrations/config

. test-lib.sh

# create an empty directory somewhere which is treated as our 'project'
# directory for the scope of this test
dir=$(mktemp -d -t migrate-test)
cd $dir
# create an empty migrations directory
mkdir migrations

# run the migrate script and expect it to fail
stdout=$($migrate_cmd 2>&1 1>/dev/null)
exit_status=$?

# assertions
assert_equals 1 "$exit_status" "Expected an unsuccesful exit status"
expected_message="ERROR: Configuration 'migrations/config' not found.
Please add the configuration file named 'config' to the migrations directory"
assert_equals "$expected_message" "$stdout" "Did not receive the expected error message"

# teardown
rm -rf $dir
