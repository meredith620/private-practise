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
    do_check ${myarg[0]} ${myarg[1]}
done < $RXCONFIG
