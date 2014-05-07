#! /bin/bash
##################################################################
#   Filename   :  deploy.sh
#   Description:  do deploy
#   Version    :  1.0
#
#   Author     :  lvliang
#   Department :  
#   Company    :  
#========= history ==========
#date		author	content
#2012-03-20	lvliang	created
##################################################################

############# local function #############
declare -a fail;
display_result()
{
#显示启动结果信息
    if ((${#fail[@]} == 0));then
           echo -e "\e[1;32;40m[finish!]\e[m"
    else
           echo -e "\e[1;31;40m[failed!]\e[m in"
           for x in ${fail[@]};
           do
                  echo -e "\t" "$x"
           done
    fi    
}

get_error_msg()
{
    for x in $@
    do
           fail[${#fail[@]}]=$x
    done
}
###########################################
args=(model_var conf_dir action)
if (($# != ${#args[@]}));then
    echo "ERROR: $0 ${args[@]}"
    exit 1
fi

SCCUESS=0
ERROR=1
model_var_file=$1
conf_dir=$2
action=$3
if [[ $action == "none" ]];then
    exit 0
fi

tmp_dir="temp"
if [ ! -d ${tmp_dir} ];then
    mkdir ${tmp_dir}
    if (($? != 0));then
        echo "need permission to mkdir ${tmp_dir}"
        exit 1
    fi
fi

remote_deploy()
{
    addr=$1
    local conf_dir_=$2
    local num_=$3
    local tmp_dir=$4
    DIRECT="/tmp/papa_deploy_temp"    
    deploy_cmd="rm $DIRECT -rf; mkdir $DIRECT"
    echo | ssh -o StrictHostKeyChecking=no $addr "$deploy_cmd"

    # ========test rsync ========
    rm -rf ${tmp_dir}/*
    cd $conf_dir_
    prefix="${num_}-${addr}-"
    target=`ls ${prefix}*`
    cd -
    for x in $target
    do
	   cp ${conf_dir_}/$x ${tmp_dir}/${x#${prefix}}
	   if (($? != $SCCUESS));then
		  echo "FAILED: cp conf/$x ${tmp_dir}/${x#${prefix}}"
		  return $ERROR;
	   fi
    done
    rsync -avzP ${tmp_dir}/ ${addr}:${DIRECT}/
    rm -rf ${tmp_dir}/*    
    # ===========================
    # cd $conf_dir_
    # prefix="${num_}-${addr}-"
    # target=`ls ${prefix}*`
    # cd -
    # for x in $target
    # do
    #     scp ${conf_dir_}/$x ${addr}:${DIRECT}/${x#${prefix}}
    #     if (($? != $SCCUESS));then
    #  	  echo "FAILED: scp conf/$x ${addr}:${DIRECT}/${x#${prefix}}"
    #  	  return $ERROR;
    #     fi
    # done
    # =============================
    deploy_cmd="cd $DIRECT; make $action"
    echo | ssh $addr "$deploy_cmd"
    if (($? != $SCCUESS));then
	   echo "FAILED: $deploy_cmd"
	   return $ERROR;
    fi
    
    deploy_cmd="rm $DIRECT -rf"
    echo | ssh $addr "$deploy_cmd"
}

i=0
while read line
do
    line=${line%%\#*}			# ignore comment string
    line=${line//[[:space:]]/}		# strip white space        
    if ((${#line} == 0));then 		# ignore empty
	   continue
    fi
    pos=`expr index $line "="`
    if ((pos == 0));then # section head
	   echo "new section - ${i}-$line"
	   remote_deploy ${line} $conf_dir $i ${tmp_dir}
	   if (($? != $SCCUESS));then
		  get_error_msg $line;
	   fi
	   i=$((i+1))
    fi
done < $model_var_file
rm -rf ${tmp_dir}

display_result
