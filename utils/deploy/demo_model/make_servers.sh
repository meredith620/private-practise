#! /bin/bash

for x in $@
do
    awk '{print $3}' $x | awk -F ':' '{print $1 " " $2}' >> all_server
done
