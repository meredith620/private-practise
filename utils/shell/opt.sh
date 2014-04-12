#! /bin/bash

# getopt demo
# getopts not support 
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

if (($# == 0));then
    usage
fi

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

print_var()
{
    var=$1
    echo "${var}=${!var}"
}

print_var host
print_var port
print_var master_config_file
print_var slave_config_file
print_var cluster_id
print_var second_meta_info
