#!/bin/sh
#
# When a non existent database host is specified, migrate will fail on the
# first migration.

. test-lib.sh

# check precondition: db on localhost should be up
db_host="localhost"
mysql_out=$(mysql --host=$db_host --user=somenonexistentuser 2>&1)
if [ "$mysql_out" = "ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2)" ]; then
    error "FAILURE: Can't connect to MySQL database instance on host '$db_host'"
    error "Please start a MySQL server on '$db_host' and rerun the test suite"
    exit 1
fi

# create an empty directory somewhere which is treated as our 'project'
# directory for the scope of this test
dir=$(mktemp -d -t migrate-test)
cd $dir
# create a migrations directory with a single dummy migration
mkdir migrations
touch migrations/0001-does-nothing.sql
# all required configuration settings are specified
non_existent_db_user='nonexistinguser'
echo "db_host='localhost'
db_user='$non_existent_db_user'
db_password='wrongpassword'
db_name='nonexistingdb'" > migrations/config

# run the migrate script
stdout=$($migrate_cmd 2>&1)
exit_status=$?

# expect it to succeed
expected_message="ERROR: Access denied for database user '$non_existent_db_user'.
Is the username '$non_existent_db_user' specified in the configuration correct?"
assert_equals "$expected_message" "$stdout" "Did not receive the expected error message"
assert_equals 1 "$exit_status" "Expected an unsuccesful exit status"

# teardown
rm -rf $dir
