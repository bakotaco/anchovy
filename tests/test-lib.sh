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
