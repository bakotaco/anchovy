#!/bin/sh
#
# When a migration is added with a lower number than previous ones, an error should be given

. test-lib.sh

# create an empty directory somewhere which is treated as our 'project'
# directory for the scope of this test
dir=$(mktemp -d -t migrate-test)
cd $dir
# create a migrations directory with a bunch of dummy migrations with numbers
mkdir migrations
touch migrations/0011-does-nothing.sql
# all required configuration settings are specified.
echo "db_host='localhost'
db_user='migrate_test'
db_password='m1gr4t3'
db_name='migrate_test'" > migrations/config

# run the migrate script once
stdout=$($migrate_cmd 2>&1)

# add another lower numbered migration
touch migrations/0001-does-nothing.sql
# and one with a higher id, which should be skipped because of the previous one failing
touch migrations/0012-does-nothing.sql

# and run migrate again
stdout=$($migrate_cmd 2>&1)
exit_status=$?

# expect it to fail with the following error message
expected_message="* checking for migration tables [OK]
* executing migrations
ERROR: migrations/0001-does-nothing.sql has not been executed, but a higher migration with id 11 has already been executed"
assert_equals "$expected_message" "$stdout" "Did not receive the expected error message"
assert_equals 1 "$exit_status" "Expected an unsuccesful exit status"

# teardown
rm -rf $dir
