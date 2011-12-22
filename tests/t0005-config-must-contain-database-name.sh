#!/bin/sh
#
# The database name migrate connects to is required to be specified in the
# configuration file

. test-lib.sh

# create an empty directory somewhere which is treated as our 'project'
# directory for the scope of this test
dir=$(mktemp -d -t migrate-test)
cd $dir
# create a migrations directory
mkdir migrations
# only the database host, user and password are specified in the configuration
# file
echo "db_host='somehost'
db_user='someuser'
db_password='somepassword'" > migrations/config

# run the migrate script
stdout=$($migrate_cmd 2>&1 1>/dev/null)
exit_status=$?

# expect it to fail with the specified message
expected_message="ERROR: Missing required configuration setting 'db_name' in 'migrations/config'.
Please specify the database name migrate should connect to in the config file"
assert_equals "$expected_message" "$stdout" "Did not receive the expected error message"
assert_equals 1 "$exit_status" "Expected an unsuccesful exit status"

# teardown
rm -rf $dir
