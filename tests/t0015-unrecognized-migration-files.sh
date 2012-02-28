#!/bin/sh
#
# When anchovy is run for the first time migration tables are created, which
# hold which migration have already been executed.

. ./test-lib.sh

create_valid_project

# create some valid migration
touch migrations/0001-does-nothing.sql
touch migrations/42-also-does-nothing.sql
# and a bunch of invalid migrations
touch migrations/does-not-start-with-number.sql
touch migrations/42-starts-with-number-but-does-not-end-with-dot-sql.txt
touch migrations/number-is-0001-in-between.sql
touch migrations/justaname

# run the anchovy script
set +e
stdout=$($anchovy_cmd 2>&1)
exit_status=$?
set -e

# expect it to fail
expected_message="* checking for migration tables                      [MISSING]
- creating migration tables                          [OK]
ERROR: found files in migrations/ directory which do not start with a positive number and/or have a '.sql' file extension
- migrations/42-starts-with-number-but-does-not-end-with-dot-sql.txt
- migrations/does-not-start-with-number.sql
- migrations/justaname
- migrations/number-is-0001-in-between.sql"
assert_equals "$expected_message" "$stdout" "Did not receive the expected error message"
assert_equals 1 "$exit_status" "Expected an unsuccesful exit status"

# teardown
rm -rf $dir
