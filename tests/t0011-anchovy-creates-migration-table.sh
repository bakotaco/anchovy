#!/bin/sh
#
# When anchovy is run for the first time migration tables are created, which
# hold which migration have already been executed.

. ./test-lib.sh

create_valid_project

# create a single dummy migration
touch migrations/0001-does-nothing.sql

# run the anchovy script
stdout=$($anchovy_cmd 2>&1)
exit_status=$?

# expect it to succeed

expected_message="* checking for migration tables                      [MISSING]
- creating migration tables                          [OK]
* executing migrations
- executing migrations/0001-does-nothing.sql         [OK]
Anchovy ran successfully."
assert_equals "$expected_message" "$stdout" "Did not receive the expected error message"
assert_equals 0 "$exit_status" "Expected a succesful exit status"

# teardown
rm -rf $dir
