#!/bin/sh
#
# The database user anchovy uses to connect to the database is required to be
# specified in the configuration file

. ./test-lib.sh

# create an empty directory somewhere which is treated as our 'project'
# directory for the scope of this test
create_project_dir
# create a migrations directory
mkdir migrations
# add a config file with only the database host specified
echo "db_host='somehost'" > migrations/config

# run the anchovy script
set +e
stdout=$($anchovy_cmd 2>&1)
exit_status=$?
set -e

# expect it to fail with the specified message
expected_message="ERROR: Missing required configuration setting 'db_user' in 'migrations/config'.
Please specify the user anchovy should use to connect to the database in the config file"
assert_equals "$expected_message" "$stdout" "Did not receive the expected error message"
assert_equals 1 "$exit_status" "Expected an unsuccesful exit status"
