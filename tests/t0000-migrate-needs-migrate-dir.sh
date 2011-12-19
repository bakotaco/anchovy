#!/bin/sh

# When migrate is run without a migrations dir an error should be raised

# helper
function fail {
    echo "FAIL: $1"
    exit 1
}

# our command
command="$PWD/migrate"

# create an empty directory somewhere
dir=$(mktemp -d -t migrate-test)
cd $dir

# run the migrate script and expect it to fail
stdout=$($command 2>&1 1>/dev/null)
exit_status=$?

test $exit_status = 1 || fail "Expected an unsuccesful exit status"
expected_message=$(echo "ERROR: Directory './migrations' not found.\nDid you initialize migrations for this project?")
test "$stdout" = "$expected_message" || fail "Did not receive the expected error message"

rmdir $dir
