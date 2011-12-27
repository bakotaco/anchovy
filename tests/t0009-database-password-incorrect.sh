#!/bin/sh
#
# When a wrong password is specified, migrate will fail on the first
# migration.

. test-lib.sh

# create an empty directory somewhere which is treated as our 'project'
# directory for the scope of this test
dir=$(mktemp -d -t migrate-test)
cd $dir
# create a migrations directory with a single dummy migration
mkdir migrations
touch migrations/0001-does-nothing.sql
# all required configuration settings are specified
existing_db_user='migrate_test'
echo "db_host='localhost'
db_user='$existing_db_user'
db_password='wrongpassword'
db_name='nonexistingdb'" > migrations/config

# run the migrate script
stdout=$($migrate_cmd 2>&1)
exit_status=$?

# expect it to succeed
expected_message="ERROR: Access denied for user '$existing_db_user'.
Is the password specified in the configuration file correct?"
assert_equals "$expected_message" "$stdout" "Did not receive the expected error message"
assert_equals 1 "$exit_status" "Expected an unsuccesful exit status"

# teardown
rm -rf $dir
