#! /bin/bash
readonly ROOT="$(cd $(dirname $0) && pwd)"
readonly PROGNAME=$(basename "$0")
readonly LOCKFILE_DIR=/tmp
readonly LOCK_FD=200

lock() {
    local prefix=$1
    local fd=${2:-$LOCK_FD}
    local lock_file=$LOCKFILE_DIR/$prefix.lock

    # create lock file
    eval "exec $fd>$lock_file"

    # acquier the lock
    flock -n $fd \
        && return 0 \
        || return 1
}

eexit() {
    local error_str="$@"

    echo $error_str
    exit 1
}

try_lock() {
    lock $PROGNAME \
        || eexit "Only one instance of $PROGNAME can run at one time."
}

main() {
    try_lock

    echo "doing job 1"
    sleep 10
    echo "doing job 2"
    sleep 10
}

# ===== main entry =====
if [[ "${BASH_SOURCE[0]}" == "$0" ]];then
    main $*
fi
