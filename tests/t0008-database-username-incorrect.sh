#!/bin/sh
#
# When a non existent database host is specified, anchovy will fail on the
# first migration.

. ./test-lib.sh

# create an empty directory somewhere which is treated as our 'project'
# directory for the scope of this test
dir=$(mktemp -d -t anchovy-test)
cd $dir
# create a migrations directory with a single dummy migration
mkdir migrations
touch migrations/0001-does-nothing.sql
# all required configuration settings are specified
non_existent_db_user='nonexistinguser'
echo "db_host='$db_host'
db_user='$non_existent_db_user'
db_password='$db_password'
db_name='$db_name'" > migrations/config

# run the anchovy script
stdout=$($anchovy_cmd 2>&1)
exit_status=$?

# expect it to succeed
expected_message="ERROR: Access denied for database user '$non_existent_db_user'.
Is the username '$non_existent_db_user' specified in the configuration correct?"
assert_equals "$expected_message" "$stdout" "Did not receive the expected error message"
assert_equals 1 "$exit_status" "Expected an unsuccesful exit status"

# teardown
rm -rf $dir
