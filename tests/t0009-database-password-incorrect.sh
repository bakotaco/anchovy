#!/bin/sh
#
# When a wrong password is specified, anchovy will fail on the first
# migration.

. ./test-lib.sh

# create an empty directory somewhere which is treated as our 'project'
# directory for the scope of this test
create_project_dir
# create a migrations directory with a single dummy migration
mkdir migrations
touch migrations/0001-does-nothing.sql
# all required configuration settings are specified, but only host and
# username are correct. Note that anchovy only reports that the password is
# incorrect, as authorization for the specified non existing database can only
# be checked after authentication.
echo "db_host='$db_host'
db_user='$db_username'
db_password='wrongpassword'
db_name='nonexistingdb'" > migrations/config

# run the anchovy script
set +e
stdout=$($anchovy_cmd 2>&1)
exit_status=$?
set -e

# expect it to fail
# NOTE: we can't determine whether the username or password are wrong, so we
#       mention both in the error
expected_message="ERROR: Access denied for database user '$db_username'.
Are the username '$non_existent_db_user' and password specified in the configuration correct?"
assert_equals "$expected_message" "$stdout" "Did not receive the expected error message"
assert_equals 1 "$exit_status" "Expected an unsuccesful exit status"

# teardown
rm -rf $dir
