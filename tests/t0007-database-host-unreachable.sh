#!/bin/sh
#
# When a non existent database host is specified, anchovy will fail on the
# first migration.

. ./test-lib.sh

# create an empty directory somewhere which is treated as our 'project'
# directory for the scope of this test
create_project_dir
# create a migrations directory with a single dummy migration
mkdir migrations
touch migrations/0001-does-nothing.sql
# all required configuration settings are specified
echo "db_host='nonexistentdatabasehost'
db_user='$db_username'
db_password='$db_password'
db_name='$db_name'" > migrations/config

# run the anchovy script
set +e
stdout=$($anchovy_cmd 2>&1)
exit_status=$?
set -e

# expect it to succeed
expected_message="ERROR: Cannot connect to host 'nonexistentdatabasehost'.
Is the host specified in the configuration file up and reachable?"
assert_equals "$expected_message" "$stdout" "Did not receive the expected error message"
assert_equals 1 "$exit_status" "Expected an unsuccesful exit status"
