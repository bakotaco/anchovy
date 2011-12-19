#!/bin/sh

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
out=$($command)
test $? = 1 || fail "expected an unsuccesful exit status"
