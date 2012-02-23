#!/bin/sh
#
# When anchovy is run for the second time, the executed migrations are not executed again

. test-lib.sh

create_valid_project

# create a single dummy migration
touch migrations/0001-does-nothing.sql

# run the anchovy script once
stdout=$($anchovy_cmd 2>&1)

# and again
stdout=$($anchovy_cmd 2>&1)
exit_status=$?

# expect it to succeed without having executed new migrations

expected_message="* checking for migration tables                      [OK]
* executing migrations
- already executed migrations/0001-does-nothing.sql
Anchovy ran successfully."
assert_equals "$expected_message" "$stdout" "Did not receive the expected error message"
assert_equals 0 "$exit_status" "Expected a succesful exit status"

# teardown
rm -rf $dir
