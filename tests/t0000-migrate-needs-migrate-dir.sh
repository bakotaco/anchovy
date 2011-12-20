#!/bin/sh
#
# When migrate is run without a migrations dir an error should be raised
#

. test-lib.sh

# create an empty directory somewhere and navigate to it
dir=$(mktemp -d -t migrate-test)
cd $dir

# run the migrate script and expect it to fail
stdout=$($migrate_cmd 2>&1 1>/dev/null)
exit_status=$?

test $exit_status = 1 || fail "Expected an unsuccesful exit status"
expected_message="ERROR: Directory 'migrations' not found.
Did you initialize migrations for this project?"
test "$stdout" = "$expected_message" || fail "Did not receive the expected error message"

rmdir $dir
