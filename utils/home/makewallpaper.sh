#! /bin/bash

#=============== service ===============
# $LINENO for the current line number $0 for the current file
# "BASH_SOURCE" and "BASH_LINENO" built-in arrays
# ROTATELOG="/usr/sbin/rotatelogs -l -e logs/log.%Y-%m-%d 86400"
CURFILE=$(basename $0)
_LOG_HDR_FMT="%.23s"
_LOG_MSG_FMT="[${_LOG_HDR_FMT}][${CURFILE}:%s][%b]: %b\n"
log_msg() {
    local lineno=$1
    local tp=$2
    local msg="$3"
    printf "$_LOG_MSG_FMT" $(date +%F.%T.%N) ${lineno} "${tp}" "${msg}"
}
log_info() {
    local msg="$1"
    log_msg ${BASH_LINENO[0]} "\033[32mINFO\033[0m" "$msg"
}
log_error() {
    local msg="$1"
    log_msg ${BASH_LINENO[0]} "\033[31mERROR\033[0m" "$msg"
}
#======================================
workdir="work"
screen_arr=("1920x1200" "1920x1080")
temp_arr=()
pic_arr=()

usage() {
    echo "screen: ${screen_arr[@]}
          $0 -p pic1 [-p pic2] -o output"
    exit 1
}

while getopts ":p:o:" opt; do
    case $opt in
        p)
            pic_arr+=($OPTARG)
            echo "fetch: $OPTARG"
            ;;
        o)
            output=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            usage
            exit 1
            ;;
    esac
done

prepare() {
    test ! -d $workdir && mkdir -p $workdir
    rm -rf $workdir/*    
}

check_args() {
    test -z $output && usage
    test 0 -eq ${#pic_arr[@]} && usage    
}

# ------------ pic ------------
get_side() {
    local size="$1"
    local mode="$2"
    local side=0
    if [[ "$mode" == "x" ]]; then
        side=${size%x*}
    elif [[ "$mode" == "y" ]]; then
        side=${size#*x}
    fi
    echo $side
}

calc_math(){
    local cmd="$1"
    python3 -c "print($cmd)"
}

calc_crop_pos() {
    local screen_size="$1"
    local pic_size="$2"
    local screen_x=$(get_side $screen_size "x")
    local screen_y=$(get_side $screen_size "y")
    local pic_x=$(get_side $pic_size "x")
    local pic_y=$(get_side $pic_size "y")
    local crop_x=$((screen_x < pic_x ? screen_x : pic_x))
    local crop_y=$((screen_y < pic_y ? screen_y : pic_y))
    if ((screen_x <= pic_x && screen_y <= pic_y)); then
        crop_x=$screen_x
        crop_y=$screen_y
    elif ((screen_x <= pic_x && screen_y > pic_y)); then
        crop_x=$(calc_math "$screen_x * $pic_y / $screen_y")
        crop_y=$pic_y
    elif ((screen_x > pic_x && screen_y <= pic_y)); then
        crop_x=$pic_x
        crop_y=$(calc_math "$screen_y * $pic_x / $screen_x")
    else
        local screen_ratio=$(calc_math "$screen_x / $screen_y")
        local pic_ratio=$(calc_math "$pic_x / $pic_y")
        if [[ "$screen_ratio" > "$pic_ratio" ]]; then
            crop_x=$pic_x
            crop_y=$(calc_math "$screen_y * $pic_x / $screen_x")
        else
            crop_x=$(calc_math "$screen_x * $pic_y / $screen_y")
            crop_y=$pic_y
        fi
    fi
    crop_x=$(calc_math "round(${crop_x})")
    crop_y=$(calc_math "round(${crop_y})")
    echo "${crop_x}x${crop_y}"
}

get_pic_size() {
    local pic="$1"
    identify "$pic" | awk '{print $3}'
}

do_crop() {
    for ((i=0; i<${#screen_arr[@]}; i++)); do
        if ((i<${#pic_arr[@]})); then
            local pic="${pic_arr[i]}"
        else
            local pic="${pic_arr[-1]}"
        fi
        local pic_size=$(get_pic_size "$pic")
        local screen_size=${screen_arr[i]}
        local crop_size=$(calc_crop_pos $screen_size $pic_size)
        local temp="${workdir}/temp_${pic}"
        temp_arr+=("$temp")
        convert -crop "${crop_size}+0+0" "$pic" "${temp}"
    done
}

do_merge() {
    echo "convert ${temp_arr[@]} +append $output"
    convert ${temp_arr[@]} +append $output
}

dotest() {
    test_arr=("1920x1080" "2000x2000" "1920x1080" "1200x600")
    for ((i=0; i < ${#test_arr[@]}; i+=2));do
        local crop_pos=$(calc_crop_pos "${test_arr[i]}" "${test_arr[i+1]}")
        echo "test: (${test_arr[i]} ${test_arr[i+1]}) => ${crop_pos}"
    done
}

main() {
    check_args
    prepare
    do_crop
    do_merge
}

# ===== main =====
if [[ "${BASH_SOURCE[0]}" == "$0" ]];then
    main "$*"
fi
