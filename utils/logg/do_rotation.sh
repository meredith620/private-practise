#! /bin/bash

args=(log_dir original_log name_prefix name_suffix rotation_num)

usage()
{
    echo "
usage: $0 log_dir original_log name_prefix name_suffix rotation_num
"
    exit 1
}

if (( $# != ${#args[@]} ));then
    usage
fi

log_dir=$1
original_log=$2
name_prefix=$3
name_suffix=$4
rotation_num=$5
cur_time=$(date '+%Y%m%d_%H%M%S')

# change working dir
# pushd .
cd $log_dir

if [ ! -e $original_log ];then
    echo "need original_log"
    exit 1
fi

cp $original_log ${name_prefix}-${cur_time}-${name_suffix}
echo -n "" > $original_log

total_num=$(ls ${name_prefix}-*-${name_suffix} | wc -l)
remove_num=$((total_num - rotation_num))
if ((remove_num > 0));then
    ls ${name_prefix}-*-${name_suffix} | sort | head -n ${remove_num} | xargs rm
fi
