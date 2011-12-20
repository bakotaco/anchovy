# our command
migrate_cmd="$PWD/../migrate"

# helper
function fail {
    echo "FAIL: $1" 1>&2
    exit 1
}
