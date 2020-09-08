#! /bin/bash
CURFILE=$(basename $0)
_ERR_HDR_FMT="%.23s"
_ERR_MSG_FMT="[${_ERR_HDR_FMT}][$USER@$HOSTNAME][${CURFILE}:%s][ %b ]: %b\n"
log_msg()
{
    local lineno=$1
    local tp=$2
    local msg="$3"
    printf "$_ERR_MSG_FMT" $(date +%F.%T.%N) ${lineno} "${tp}" "${msg}" 1>&2
}
log_info()
{
    local msg="$1"
    log_msg ${BASH_LINENO[0]} "\033[32mINFO\033[0m" "$msg"
}
log_warning()
{
    local msg="$1"
    log_msg ${BASH_LINENO[0]} "\033[33mWARN\033[0m" "$msg"
}
log_error()
{
    local msg="$1"
    log_msg ${BASH_LINENO[0]} "\033[31mERROR\033[0m" "$msg"
}
#----------------------------------------------------------------------------
ROOT="$(cd $(dirname $0) && pwd)"
ROOT=${ROOT%/}
USER_BACKUP_HOME="__home"
TEST=false

is_dir() {
    local target="$1"
    sudo file "$target" | grep directory > /dev/null
    ret=$?
    return ${ret}
}

do_copy() {
    local sudo=$1
    local src=$2
    local target_parent=$3
    TEST_CMD=test
    CP=cp
    if [ $sudo == true ]; then
        CP="sudo $CP"
        TEST_CMD="sudo $TEST_CMD"
    fi
    if [ $TEST == true ]; then
        CP="echo [DRY-RUN]: $CP"
    fi
    $TEST_CMD -e "$src" || { log_info "src: $src does not exists, skip"; return 0; }
    is_dir "$src"
    ret=$?
    if [ $ret -eq 0 ]; then
        # is dir
        echo "$CP -r ${src} ${target_parent}/"
        $CP -r ${src} ${target_parent}/
    else
        # is not dir
        echo "$CP ${src} ${target_parent}/"
        $CP ${src} ${target_parent}/
    fi
}

prepare_folder() {
    local sudo=$1
    local target_parent="$2"
    MKDIR=mkdir
    if [ $sudo == true ]; then
        MKDIR="sudo $MKDIR"
    fi
    if [ $TEST == true ]; then
        MKDIR="echo [DRY_RUN]: $MKDIR"
    fi
    $MKDIR -p ${target_parent}
}

# ------------ backup --------------
system_backup() {
    local src="$1"
    target_parent=$(dirname ${ROOT}${src})
    prepare_folder false "${target_parent}"
    do_copy true ${src} ${target_parent}
}

user_backup() {
    local src="$1"
    local home_src=${src##${HOME}/}
    home_src=/${home_src%/}

    target_parent=$(dirname "${USER_BACKUP_HOME}${home_src}")
    prepare_folder false "${target_parent}"
    do_copy false ${src} ${target_parent}
}

backup_system_and_user() {
    source $ENVFILE
    for x in ${SYSTEM_BACKUP_LIST[@]}; do
        system_backup "$x"
    done
    echo "sudo chown $USER:$USER ${ROOT} -R"
    sudo chown $USER:$USER ${ROOT} -R

    for x in ${USER_BACKUP_LIST[@]}; do
        user_backup "$x"
    done
}

# ------------ restore --------------
system_restore() {
    local src="$1"
    target_parent=$(dirname "${src}")
    prepare_folder true "${target_parent}"
    do_copy true "${ROOT}${src}" "${target_parent}"
}

user_restore() {
    local target="$1"
    local sub_target=${target#"${HOME}/"}
    local src="${USER_BACKUP_HOME}/${sub_target}"
    local target_parent=$(dirname "${target}")
    prepare_folder false "${target_parent}"
    do_copy false "${src}" "${target_parent}"
}

restore_system_and_user() {
    source $ENVFILE
    for x in ${SYSTEM_BACKUP_LIST[@]}; do
        system_restore "$x"
    done
    for x in ${USER_BACKUP_LIST[@]}; do
        user_restore "$x"
    done
}

usage() {
    echo "$0 [OPTIONS]
	-m mode [backup|restore]
	-e env-file
    	-t test dry-run, default false"
    exit 1
}

check_parameters() {
    if [ -z $MODE ] || ([ "$MODE" != "backup" ] && [ "$MODE" != "restore" ]); then
        log_error "unrecognized parameter MODE: '$MODE'"
        usage
    fi
    if [ -z $ENVFILE ] || [ ! -e $ENVFILE ]; then
        log_error "file not exists, ENVFILE: ${ENVFILE}"
        usage
    fi
}

main() {
    while getopts "tm:e:h" opt; do
        case "$opt" in
            m)
                MODE="${OPTARG}"
                ;;
            e)
                ENVFILE="${OPTARG}"
                ;;
            t)
                TEST=true
                ;;
            h)
                usage
                ;;
            *)
                usage
                ;;
        esac
    done
    check_parameters
    if [ "$MODE" == "backup" ]; then
        backup_system_and_user
    elif [ "$MODE" == "restore" ]; then
        restore_system_and_user
    fi
}

# ===== main =====
if [[ "${BASH_SOURCE[0]}" == "$0" ]];then
    main $*
fi
