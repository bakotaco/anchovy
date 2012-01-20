#!/bin/sh
#
# When all required configuration settings are present, but there are no
# migration to run, migrate will exit successfully

. test-lib.sh

# create an empty directory somewhere which is treated as our 'project'
# directory for the scope of this test
dir=$(mktemp -d -t migrate-test)
cd $dir
# create a migrations directory
mkdir migrations
# all required configuration settings are specified
echo "db_host='localhost'
db_user='migrate_test'
db_password='m1gr4t3'
db_name='migrate_test'" > migrations/config

# run the migrate script
stdout=$($migrate_cmd 2>&1)
exit_status=$?

# expect it to succeed
expected_message="Migrate ran successfully."
assert_matches "${expected_message}$" "$stdout" "Did not receive the expected error message"
assert_equals 0 "$exit_status" "Expected a succesful exit status"

# teardown
rm -rf $dir
