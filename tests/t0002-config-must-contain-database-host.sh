#!/bin/sh
#
# The database host anchovy connects to is required to be specified in the configuration file

. test-lib.sh

# create an empty directory somewhere which is treated as our 'project'
# directory for the scope of this test
dir=$(mktemp -d -t anchovy-test)
cd $dir
# create a migrations directory
mkdir migrations
# create an empty configuration file
touch migrations/config

# run the anchovy script
set +e
stdout=$($anchovy_cmd 2>&1)
exit_status=$?
set -e

# expect it to fail with the specified message
expected_message="ERROR: Missing required configuration setting 'db_host' in 'migrations/config'.
Please specify the hostname anchovy should connect to in the config file"
assert_equals "$expected_message" "$stdout" "Did not receive the expected error message"
assert_equals 1 "$exit_status" "Expected an unsuccesful exit status"

# teardown
rm -rf $dir
