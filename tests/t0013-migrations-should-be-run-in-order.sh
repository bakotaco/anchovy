#!/bin/sh
#
# Migrations should be run in order by how they are numbered

. test-lib.sh

# create an empty directory somewhere which is treated as our 'project'
# directory for the scope of this test
dir=$(mktemp -d -t migrate-test)
cd $dir
# create a migrations directory with a bunch of dummy migrations with numbers
mkdir migrations
touch migrations/0011-does-nothing.sql
touch migrations/0001-does-nothing.sql
touch migrations/012-does-nothing.sql
touch migrations/02-does-nothing.sql
touch migrations/111-does-nothing.sql
# all required configuration settings are specified.
echo "db_host='localhost'
db_user='migrate_test'
db_password='m1gr4t3'
db_name='migrate_test'" > migrations/config

# run the migrate script once
stdout=$($migrate_cmd 2>&1)
exit_status=$?

# expect it to succeed with the migration executed in the numbered order

expected_message="* checking for migration tables [MISSING]
- creating migration tables [OK]
* executing migrations
- executing migrations/0001-does-nothing.sql
- executing migrations/02-does-nothing.sql
- executing migrations/0011-does-nothing.sql
- executing migrations/012-does-nothing.sql
- executing migrations/111-does-nothing.sql
Migrate ran successfully."
assert_equals "$expected_message" "$stdout" "Did not receive the expected error message"
assert_equals 0 "$exit_status" "Expected a succesful exit status"

# teardown
rm -rf $dir
