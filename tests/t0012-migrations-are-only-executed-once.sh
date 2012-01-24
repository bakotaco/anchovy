#!/bin/sh
#
# When migrate is run for the second time, the executed migrations are not executed again

. test-lib.sh

# create an empty directory somewhere which is treated as our 'project'
# directory for the scope of this test
dir=$(mktemp -d -t migrate-test)
cd $dir
# create a migrations directory with a single dummy migration
mkdir migrations
touch migrations/0001-does-nothing.sql
# all required configuration settings are specified.
echo "db_host='localhost'
db_user='migrate_test'
db_password='m1gr4t3'
db_name='migrate_test'" > migrations/config

# run the migrate script once
stdout=$($migrate_cmd 2>&1)

# and again
stdout=$($migrate_cmd 2>&1)
exit_status=$?

# expect it to succeed without having executed new migrations

expected_message="* checking for migration tables [OK]
* executing migrations
- already executed migrations/0001-does-nothing.sql
Migrate ran successfully."
assert_equals "$expected_message" "$stdout" "Did not receive the expected error message"
assert_equals 0 "$exit_status" "Expected a succesful exit status"

# teardown
rm -rf $dir
