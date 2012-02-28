#!/bin/sh
#
# Migrations should be run in order by how they are numbered

. ./test-lib.sh

create_valid_project

# create a bunch of dummy migrations with numbers
touch migrations/0011-does-nothing.sql
touch migrations/0001-does-nothing.sql
touch migrations/012-does-nothing.sql
touch migrations/02-does-nothing.sql
touch migrations/111-does-nothing.sql

# run the anchovy script once
stdout=$($anchovy_cmd 2>&1)
exit_status=$?

# expect it to succeed with the migration executed in the numbered order

expected_message="* checking for migration tables                      [MISSING]
- creating migration tables                          [OK]
* executing migrations
- executing migrations/0001-does-nothing.sql         [OK]
- executing migrations/02-does-nothing.sql           [OK]
- executing migrations/0011-does-nothing.sql         [OK]
- executing migrations/012-does-nothing.sql          [OK]
- executing migrations/111-does-nothing.sql          [OK]
Anchovy ran successfully."
assert_equals "$expected_message" "$stdout" "Did not receive the expected error message"
assert_equals 0 "$exit_status" "Expected a succesful exit status"
