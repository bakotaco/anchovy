# our command
migrate_cmd="$PWD/../migrate"

# helpers
function error {
    echo $* 1>&2
}

function fail {
    error "FAIL: $1"
    exit 1
}

function assert_equals {
    if [ "$1" != "$2" ]; then
        error "FAILURE: '$3'"
        error "expected: '$1'"
        error "actual: '$2'"
        exit 1;
    fi
}

# check preconditions for all tests

# verify that a database for testing purposes is up and running with the
# following settings
db_host="localhost"
db_username="migrate_test"
db_password="m1gr4t3"
db_name="migrate_test"
mysql_out=$(mysql --host="$db_host" --user="$db_username" --password="$db_password" --database="$db_name" </dev/null 2>&1)
if [ $? != 0 ]; then
    echo $mysql_out
    error "FAILURE: Unable to connect to database for testing purposes"
    error "The test suite expects:"
    error "- a MySQL server running at '$db_host'"
    error "- a database user with username '$db_username' and password '$db_password'"
    error "- a database named '$db_name'"
    exit 255
fi
