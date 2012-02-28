#!/bin/sh
#
# When there are migrations with duplicate numbers, anchovy should always fail
# so we can manually resolve the conflict.

. ./test-lib.sh

create_valid_project

# create a migration
cat > migrations/1-and-only.sql <<EOF
CREATE TABLE foo (bar INT);
EOF

# run anchovy once
$anchovy_cmd >/dev/null

# change the content of the already executed migration
cat > migrations/1-and-only.sql <<EOF
CREATE TABLE foo (bar INT DEFAULT 42);
EOF

# run anchovy again
set +e
stdout=$($anchovy_cmd 2>&1)
exit_status=$?
set -e

# expect it to fail
expected_message="* checking for migration tables                      [OK]
* executing migrations
ERROR: found already executed migration which has been altered since executing it:
- migrations/1-and-only.sql"
assert_equals "$expected_message" "$stdout" "Did not receive the expected error message"
assert_equals 1 "$exit_status" "Expected an unsuccesful exit status"
