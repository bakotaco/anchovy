#!/bin/sh
#
# When a migration is added with a lower number than previous ones, an error should be given

. test-lib.sh

create_valid_project

# create a migration with id 11 and run anchovy once
touch migrations/0011-does-nothing.sql
$anchovy_cmd >/dev/null 2>&1

# add another lower numbered migration
touch migrations/0001-does-nothing.sql
# and one with a higher id, which should be skipped because of the previous one failing
touch migrations/0012-does-nothing.sql

# and run anchovy again
stdout=$($anchovy_cmd 2>&1)
exit_status=$?

# expect it to fail with the following error message
expected_message="* checking for migration tables                      [OK]
* executing migrations
ERROR: migrations/0001-does-nothing.sql has not been executed, but a higher migration with id 11 has already been executed"
assert_equals "$expected_message" "$stdout" "Did not receive the expected error message"
assert_equals 1 "$exit_status" "Expected an unsuccesful exit status"

# teardown
rm -rf $dir
