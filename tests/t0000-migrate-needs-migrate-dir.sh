#!/bin/sh
#
# When migrate is run without a migrations dir an error should be raised
#

. test-lib.sh

# create an empty directory somewhere which is treated as our 'project'
# directory for the scope of this test. there is no migrations subdirectory.
dir=$(mktemp -d -t migrate-test)
cd $dir

# run the migrate script and expect it to fail
stdout=$($migrate_cmd 2>&1)
exit_status=$?

# assertions
assert_equals 1 "$exit_status" "Expected an unsuccesful exit status"
expected_message="ERROR: Directory 'migrations' not found.
Did you initialize migrations for this project?"
assert_equals "$expected_message" "$stdout" "Did not receive the expected error message"

# teardown
rmdir $dir
