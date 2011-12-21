#!/bin/sh
#
# The database user migrate uses to connect to the database is required to be
# specified in the configuration file

. test-lib.sh

# create an empty directory somewhere and navigate to it with a migrations dir
dir=$(mktemp -d -t migrate-test)
cd $dir
mkdir migrations
# add a config file with only the database host specified
echo "db_host='somehost'" > migrations/config

# run the migrate script
stdout=$($migrate_cmd 2>&1 1>/dev/null)
exit_status=$?

# expect it to fail with the specified message
expected_message="ERROR: Missing required configuration setting 'db_user' in 'migrations/config'.
Please specify the user migrate should use to connect to the database in the config file"
assert_equals "$expected_message" "$stdout" "Did not receive the expected error message"
assert_equals 1 "$exit_status" "Expected an unsuccesful exit status"

# teardown
rm -rf $dir
