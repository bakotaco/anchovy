#!/bin/sh
#
# Migrations don't necessarily need to be numbered naturally, instead they
# could also be numbered with high numbers, such as dates or timestamps. We
# need to make sure highly numbered migrations are carried out correctly and
# in order.

# pros/cons of natural number migrations:
# + date/time not necessary
# - date/time with high accuracy less likely to cause conflicts
#
# pros/cons of date/time numbered migrations:
# + conflicts avoided, but that is not necessarily a good thing
# 

. test-lib.sh

create_valid_project

# the smallest migration
touch migrations/1-test.sql
# some numbered by date
touch migrations/20091231-test.sql
touch migrations/20091229-test.sql
touch migrations/20091230-test.sql
# date and time
touch migrations/20080101123208-test.sql
touch migrations/20080101123206-test.sql
touch migrations/20080101123307-test.sql

18446744073709551615
20120222081446768285500
2012-02-22 08:14:46.768285500

# and a few really large ones
touch migrations/999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999997-test.sql
touch migrations/999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999-test.sql
touch migrations/999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999998-test.sql

# When we run anchovy
stdout=$($anchovy_cmd 2>&1)
exit_status=$?

# Then we expect it to succeed
expected_message="* checking for migration tables                      [MISSING]
- creating migration tables                          [OK]
* executing migrations
- executing migrations/0001-does-nothing.sql         [OK]
- executing migrations/02-does-nothing.sql           [OK]
- executing migrations/0011-does-nothing.sql         [OK]
- executing migrations/012-does-nothing.sql          [OK]
- executing migrations/111-does-nothing.sql          [OK]
Anchovy ran successfully."
assert_equals "$expected_message" "$stdout" "Did not receive the expected error message"
assert_equals 0 "$exit_status" "Expected a succesful exit status"

# teardown
rm -rf $dir
