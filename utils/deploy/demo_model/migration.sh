#! /bin/bash
#do  migration list format
#001     268435456       127.0.0.1:6671  ->slaveof       127.0.0.1:6670
#003     268435456       127.0.0.1:6673  ->slaveof       127.0.0.1:6672

args=(mig_list)
source librediscmd_sh
redis_cli_bin="RXINSTALL_ROOT/RXBIN_PATH/redis-cli"
usage()
{
    echo "
usage: $0 mig_list
"
    exit 1
}

if (($# != ${#args[@]}));then
    usage
fi

mig_list=$1


if [ ! -e $mig_list ];then
    echo "file not exist: $mig_list"
    exit 1
fi

while read line
do
    info=$(echo "$line" | awk '{print $3 " " $5}')
    slave_host_port=${info% *}
    master_host_port=${info#* }
    slave_host=${slave_host_port%:*}
    slave_port=${slave_host_port#*:}
    master_host=${master_host_port%:*}
    master_port=${master_host_port#*:}
    do_migration $redis_cli_bin $slave_host $slave_port $master_host $master_port
done < $mig_list

