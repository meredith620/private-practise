#! /bin/bash

# ============= utils =============
# $LINENO for the current line number $0 for the current file
# "BASH_SOURCE" and "BASH_LINENO" built-in arrays 
CURFILE=$(basename $0)
_ERR_HDR_FMT="%.23s"
_ERR_MSG_FMT="[${_ERR_HDR_FMT}][${CURFILE}:%s][%s]: %s\n"
log_msg()
{
    local lineno=$1
    local tp=$2
    local msg="$3"
    printf "$_ERR_MSG_FMT" $(date +%F.%T.%N) ${lineno} ${tp} "${msg}" 1>&2
}
log_debug()
{
    local msg="$1"
    log_msg ${BASH_LINENO[0]} "DEBUG" "$msg"
}
log_error()
{
    local msg="$1"
    log_msg ${BASH_LINENO[0]} "ERROR" "$msg"
}
exec_cmd()
{
    local cmd="$1"
    log_debug "[DO_CMD]: $cmd"
    eval "$cmd"
    return $?
}
cur_time() {
    date +%F.%T
}
# ====================================

main()
{
    exec_cmd "ls /"
    log_debug "this is a debug msg"
    log_error "this is a error msg"
}
# ===== main =====
main
