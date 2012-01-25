# our command
migrate_cmd="$PWD/../migrate"

# helpers
function error {
    echo "$*" 1>&2
}

function fail {
    error "FAIL: $1"
    exit 1
}

function assert_equals {
    if [ "$1" != "$2" ]; then
        error "FAILURE: '$3'"
        error ">>> expected:\n'$1'"
        error ">>> actual:\n'$2'"
        exit 1;
    fi
}

function assert_matches {
    if echo "$2" | grep "$1"; then
        # TODO: can't we simply negate the previous check? can that be done
        # easy and elegantly?
        true
    else
        error "FAILURE: '$3'"
        error "pattern: '$1'"
        error "source: '$2'"
        exit 1;
    fi
}

# check preconditions for all tests

# verify that a database for testing purposes is up and running with the
# following settings
db_host="localhost"
db_username="migrate_test"
db_password="m1gr4t3"
db_name="migrate_test_db"
MYSQL_COMMAND="mysql --host=$db_host --user=$db_username --password=$db_password --database=$db_name"
mysql_out=$($MYSQL_COMMAND </dev/null 2>&1)
if [ $? != 0 ]; then
    echo $mysql_out
    error "FAILURE: Unable to connect to database for testing purposes"
    error "The test suite expects:"
    error "- a MySQL server running at '$db_host'"
    error "- a database user with username '$db_username' and password '$db_password'"
    error "- a database named '$db_name'"
    # NOTE: this exit code signals the makefile that a prerequisite has not
    # been met
    exit 255
fi

echo 'drop table migrations' | $MYSQL_COMMAND

# helper method for creating a stub project with a valid config
function create_valid_project {

    # create an empty directory somewhere which is treated as our 'project'
    # directory for the scope of this test
    dir=$(mktemp -d -t migrate-test)
    cd $dir

    # create a migrations directory
    mkdir migrations

    # all required configuration settings are specified.
    echo "db_host='$db_host'
db_user='$db_username'
db_password='$db_password'
db_name='$db_name'" > migrations/config

}
