#!/bin/sh
#
# When a wrong database name is specified, anchovy will fail on the first
# migration. The error for when a non existing and when an existing, but
# unprivileged database is attempted to be accessed is the same, because we
# can't determine the difference.

. ./test-lib.sh

# create an empty directory somewhere which is treated as our 'project'
# directory for the scope of this test
dir=$(mktemp -d -t anchovy-test)
cd $dir
# create a migrations directory with a single dummy migration
mkdir migrations
touch migrations/0001-does-nothing.sql
# all required configuration settings are specified.
# the following database should not exist or the specified user should not
# have access to it
non_existent_db_name="nonexistingdb"
echo "db_host='$db_host'
db_user='$db_username'
db_password='$db_password'
db_name='$non_existent_db_name'" > migrations/config

# run the anchovy script
stdout=$($anchovy_cmd 2>&1)
exit_status=$?

# expect it to succeed
expected_message="ERROR: Access denied to database with name '$non_existent_db_name'.
Is the database name specified in the configuration file correct?
Does the specified database exist?
Does the specified user have access privileges to the specified database?"
assert_equals "$expected_message" "$stdout" "Did not receive the expected error message"
assert_equals 1 "$exit_status" "Expected an unsuccesful exit status"

# teardown
rm -rf $dir
