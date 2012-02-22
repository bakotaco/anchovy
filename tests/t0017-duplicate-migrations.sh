#!/bin/sh
#
# When there are migrations with duplicate numbers, anchovy should always fail
# so we can manually resolve the conflict.

. ./test-lib.sh

create_valid_project

# create some migrations
touch migrations/1-does-nothing.sql
touch migrations/2-also-does-nothing.sql
touch migrations/3-and-another.sql

# run anchovy once
$anchovy_cmd >/dev/null

# add a duplicate of an already executed migration
touch migrations/2-is-duplicate.sql
# add a few new migrations
touch migrations/4-foo.sql
touch migrations/5-bar.sql
touch migrations/6-baz.sql
# and another duplicate
touch migrations/5-duplicate.sql

# run anchovy again
stdout=$($anchovy_cmd 2>&1)
exit_status=$?

# expect it to fail
expected_message="* checking for migration tables                      [OK]
ERROR: found migrations with duplicate numbers:
- migrations/2-also-does-nothing.sql
- migrations/2-is-duplicate.sql
- migrations/5-bar.sql
- migrations/5-duplicate.sql"
assert_equals "$expected_message" "$stdout" "Did not receive the expected error message"
assert_equals 1 "$exit_status" "Expected an unsuccesful exit status"

# teardown
rm -rf $dir
