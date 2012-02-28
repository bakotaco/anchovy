# exit when uninitialised variables encountered
set -u
# exit upon error
set -e

# our command
anchovy_cmd="$PWD/../anchovy"

# set TMPDIR when unset for use in our mktemp template
TMPDIR=${TMPDIR:-/tmp}

# helpers
error () {
    echo "$*" 1>&2
}

fail () {
    error "FAIL: $1"
    exit 1
}

assert_equals () {
    if [ "$1" != "$2" ]; then
        error "FAILURE: '$3'"
        # when diff is available
        if which diff >/dev/null; then
            # show difference using a unified diff
            error "Diff of expected and actual follows:"
            expected_file=$(mktemp "$TMPDIR/anchovy-test-expected-XXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
            actual_file=$(mktemp "$TMPDIR/anchovy-test-actual-XXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
            echo "$1" > $expected_file
            echo "$2" > $actual_file
            diff -U10000 $expected_file $actual_file
            exit 1
        else
            # else let the user look for the difference himself
            error ">>> expected:"
            error "$1"
            error "<<<"
            error ">>> actual:"
            error "$2"
            error "<<<"
            exit 1;
        fi
        exit
    fi
}

assert_matches () {
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
db_username="anchovy_test"
db_password="m1gr4t3"
db_name="anchovy_test_db"
MYSQL_COMMAND="mysql --host=$db_host --user=$db_username --password=$db_password --database=$db_name"
mysql_out=$($MYSQL_COMMAND </dev/null 2>&1)
if [ $? != 0 ]; then
    echo $mysql_out
    error "FAILURE: Unable to connect to database for testing purposes"
    error ""
    error "The test suite expects:"
    error "- a MySQL server running at '$db_host'"
    error "- a database user with username '$db_username' and password '$db_password'"
    error "- a database named '$db_name'"
    error ""
    error "Issuing the following commands created this database and user:"
    error ""
    error "    CREATE DATABASE $db_name;"
    error "    GRANT ALL ON $db_name.* TO '$db_username'@'localhost' IDENTIFIED BY '$db_password';"
    error " "
    # NOTE: this exit code signals the makefile that a prerequisite has not
    # been met
    exit 255
fi

# remove all tables
for table in $(echo 'SHOW TABLES' | $MYSQL_COMMAND | tail -n +2); do
    echo "DROP TABLE IF EXISTS $table" | $MYSQL_COMMAND
done

create_project_dir () {
    # create an empty directory somewhere which is treated as our 'project'
    # directory for the scope of this test
    # NOTE: mktemp is not portable
    project_dir=$(mktemp -d "$TMPDIR/anchovy-test-XXXXXXXXXXXXXXXXXXXXXXXXXXXXX") || { error "ERROR creating a temporary file"; exit 255; }
    # Remove the temporary directory when the script finishes, or when it receives a signal
    trap 'rm -rf "$project_dir"' 0       # remove directory when script finishes
    trap 'exit 2' 1 2 3 15       # terminate script when receiving signal

    cd $project_dir
}

# helper method for creating a stub project with a valid config
create_valid_project () {
    create_project_dir

    # create a migrations directory
    mkdir migrations

    # all required configuration settings are specified.
    echo "db_host='$db_host'
db_user='$db_username'
db_password='$db_password'
db_name='$db_name'" > migrations/config

}
