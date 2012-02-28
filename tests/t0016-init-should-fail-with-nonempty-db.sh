#!/bin/sh
#
# When anchovy is run for the first time it should fail when the database
# already has tables.

. ./test-lib.sh

create_valid_project

echo "CREATE TABLE foo (bar INT)" | $MYSQL_COMMAND

# run the anchovy script
set +e
stdout=$($anchovy_cmd 2>&1)
exit_status=$?
set -e

# expect it to fail
expected_message="* checking for migration tables                      [MISSING]
ERROR: database is not empty, will only initialize in an empty database."
assert_equals "$expected_message" "$stdout" "Did not receive the expected error message"
assert_equals 1 "$exit_status" "Expected an unsuccesful exit status"

# teardown
rm -rf $dir
