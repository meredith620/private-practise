#! /bin/bash

args=(cmd_file)
if (($# != ${#args[@]}));then
    echo "$0 ${args[@]}"
    exit 1
fi

cmd_file=$1

bin_cli="RXINSTALL_ROOT/RXBIN_PATH/redis-cli"
if [[ ! -e $bin_cli ]];then
    echo "ERROR $bin_cli NOT EXIST!"
    exit 1    
fi

while read line
do
    line=${line%%\#*}			# ignore comment string
    if ((${#line} == 0));then 		# ignore empty
	   continue
    fi
    
    IFS=" "
    echo "get: $line"
    myargs=($line)
    # declare -p myargs
    host=${myargs[0]}
    port=${myargs[1]}
    # echo $host $port
    temp=${line#* }	# filtout first section
    temp=${temp#* } # filtout second section
    # echo $temp
    IFS=";" cmd_array=($temp)
    # declare -p cmd_array
    
    for ((i=0; i<${#cmd_array[@]};i++))
    do
        cmd="echo \"${cmd_array[i]}\" | $bin_cli -h $host -p $port"
        echo $cmd
        eval $cmd
    done
done < $cmd_file
