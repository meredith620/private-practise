#! /bin/bash

args=(multi_num bin dir_log_prefix)
if (($# != ${#args[@]}));then
    echo "need args: ${args[@]}"
    declare -p args
    exit 1
fi

process_num=$1
bin=$2
dir_log_prefix=$3
timestamp=$(date '+%Y%m%d_%H:%M:%S')
# check process num
if ((process_num <= 0));then
    echo "multi_num must greater than 0"
    exit 1
fi

# make dir
out_dir=${dir_log_prefix%/*}
mkdir -p $out_dir
if (($? != 0));then
    echo "can't mkdir $out_dir"
    exit 1
fi
log_prefix=${timestamp}_${dir_log_prefix##*/}
make_arg()
{
    local num=$1
    echo "data_$1"
}

do_process()
{
    local cmd=$1
    local out_log=$2
    touch $out_log
    if (($? != 0));then
        echo "file $out_log can't be created"
        exit 1
    fi
    local final_cmd="nohup $cmd >& ${out_log} &"
    echo $final_cmd
    eval $final_cmd    
}


make_multi_process()
{
    local process_num=$1
    local cmd=$2
    local out_dir=$3
    i=0
    while ((i<process_num))
    do
        local arg=$(make_arg $i)
        local out_log="${out_dir}/${log_prefix}_$i.log"
        do_process "$cmd $arg" $out_log
        ((i++))
    done
}

wait_multi_process()
{
    local fails=0
    for job in `jobs -p`
    do
        wait $job || { echo "$job failed" ; ((fails++)); }
    done
    echo -n "process "
    if ((fails == 0));then
        echo -e "\033[1;32m SUCCESSED \033[0m continue..."
    else
        echo -e "\033[1;31m FAILED \033[0m abort..."
        exit 1
    fi
}

parse_logs()
{
    local dir=$1
    local prefix=$2
    echo "you have log:"
    ls ${dir}/${prefix}*
}
#===========main===========
make_multi_process $process_num "${bin} " $out_dir
wait_multi_process
parse_logs $out_dir $log_prefix
