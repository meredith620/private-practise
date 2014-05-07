#! /bin/bash

# args=()


redis_cli_bin="RXINSTALL_ROOT/RXBIN_PATH/redis-cli"
master_config_key="master_config"
slave_config_key="slave_config"
second_meta_key="second_meta"

source librediscmd_sh

usage()
{
    echo "
usage: $0 -a \$host -p \$port -i \$cluster_id [-mse] 
         -h, --help      show help info
         -a, --addr      redis server addr
         -p, --port      redis server port
         -m, --master-config     redis cluster config FILE
         -s, --slave-config      redis cluster config FILE
         -i, --cluster-id        redis cluster id
         -e, --second-meta       [host:port] redis second config server addr
"
    exit 1
}

while getopts ":a:p:m:s:i:e:" opt; do
    case $opt in
        a)
            host=$OPTARG
            ;;
        p)
            port=$OPTARG
            ;;
        m)
            master_config_file=$OPTARG
            ;;
        s)
            slave_config_file=$OPTARG
            ;;
        i)
            cluster_id=$OPTARG
            ;;
        e)
            second_meta_info=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

if [[ -z $host || -z $port || -z $cluster_id ]];then
    usage
fi

if [[ ! -z $master_config_file ]];then
    echo -e "set \033[32mmaster config\033[0m: ${master_config_file}"
    set_file ${redis_cli_bin} $host $port "${cluster_id}:${master_config_key}" ${master_config_file}
    if (( $? == 0 ));then
        echo -e "master config set \033[32mSUCCESS\033[0m!"
    else echo -e "master config set \033[31mFAILED\033[0m!"
    fi
fi

if [[ ! -z $slave_config_file ]];then
    echo -e "set \033[32mslave config\033[0m: ${slave_config_file}"
    set_file ${redis_cli_bin} $host $port "${cluster_id}:${slave_config_key}" ${slave_config_file}
    if (( $? == 0 ));then
        echo -e "slave config set \033[32mSUCCESS\033[0m!"
    else echo -e "slave config set \033[31mFAILED\033[0m!"
    fi
fi

if [[ ! -z $second_meta_info ]];then
    echo -e "set \033[32msecond meta\033[0m: ${second_meta_info}"
    set_value ${redis_cli_bin} $host $port "${cluster_id}:${second_meta_key}" ${second_meta_info}
    if (( $? == 0 ));then
        echo -e "second meta set \033[32mSUCCESS\033[0m!"
    else echo -e "second meta set \033[31mFAILED\033[0m!"
    fi
fi
