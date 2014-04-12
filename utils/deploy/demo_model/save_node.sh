#! /bin/bash

source librediscmd_sh
# check conf file
check_exis $RXCONFIG

lock_file="RXINSTALL_ROOT/RXBIN_PATH/redis_save.lck"
dead_lock_seconds=10800 #3 hours
curr_time=`date +%s`
echo "=====$(date): run====="
if [[ -e $lock_file ]];then
    #get lock timestamp
    var=$(stat $lock_file | sed -ne '/Modify/p' | awk '{print $2 " "  $3}')
    lock_time=$(date -d "${var%%.*}" +%s)
    pass_time=$((curr_time - lock_time))
    echo -e "locktime: ${lock_time}\tcurrtime: ${curr_time}\tpasstime: ${pass_time}"
    if ((pass_time > dead_lock_seconds));then
        echo "dead lock"
        touch $lock_file
    else
        echo "wait for next turn"
        exit 1;
    fi
else
    echo "touch $lock_file"
    touch $lock_file
fi

while read line
do
    line=${line%%\#*}			# ignore comment string
    if ((${#line} == 0));then 		# ignore empty
	   continue
    fi
    
    myarg=($line)
    # declare -p myarg
    do_save ${myarg[4]} ${myarg[2]} ${myarg[3]}
    sleep 500
done < $RXCONFIG

rm $lock_file
