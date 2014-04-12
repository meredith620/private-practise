#! /bin/bash

source librediscmd_sh

# check conf file
check_exis $RXCONFIG

while read line
do
    line=${line%%\#*}			# ignore comment string
    if ((${#line} == 0));then 		# ignore empty
	   continue
    fi
    
    myarg=($line)
    # declare -p myarg
    do_start ${myarg[0]} ${myarg[1]}
    sleep 1
done < $RXCONFIG
