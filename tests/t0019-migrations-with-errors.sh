#!/bin/sh
#
# When there are migrations with errors, migrate should always fail
# so we can manually resolve the conflict.

. test-lib.sh

create_valid_project

# When we first have a succesful migration
touch migrations/1-succeeds.sql
# followed by a failing one
cat > migrations/2-fails.sql <<EOF
Invalid SQL;
EOF
# and another succesful one
touch migrations/3-also-succeeds.sql

# When we run migrate
stdout=$($migrate_cmd 2>&1)
exit_status=$?

# Then we expect it to fail
expected_message="* checking for migration tables [MISSING]
- creating migration tables [OK]
* executing migrations
- executing migrations/1-succeeds.sql                 [OK]
- executing migrations/2-fails.sql                    [ERROR]
ERROR: Executing migration migrations/2-fails.sql failed, the database returned:
ERROR 1064 (42000) at line 1: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'Invalid SQL' at line 1"
assert_equals "$expected_message" "$stdout" "Did not receive the expected error message"
assert_equals 1 "$exit_status" "Expected an unsuccesful exit status"

# teardown
rm -rf $dir
