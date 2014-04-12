#! /bin/bash
##################################################################
#   Filename   :  autodeploy.sh
#   Description:  
#   Version    :  1.0
#
#   Author     :  lvliang@
#   Department :  
#   Company    :  
#========= history ==========
#date		author	content
#2012-03-20	lvliang	created
##################################################################

target_dir="conf"

model_dir=""
action="install"
args=(model_dir/XXdeply.conf operation)
if (($# != ${#args[@]}));then
    echo "$0 ${args[@]}"
    exit 1
fi

model_dir=${1%/*}
deply_conf_file=${1##*/}
action=$2

if [ ! -d "${model_dir}" ];then
    echo "$0 ${args[@]}"
    echo "ERROR: model dir not exist!"
    exit 1
fi    

cur_time=$(date '+%Y-%m-%d_%H:%M:%S')
op_log_dir=operation_log
if [ ! -d ${model_dir}/${op_log_dir} ];then
    mkdir ${model_dir}/${op_log_dir}
fi

deploy_one()
{
    deploy_conf=$1
    sed_list=$2
    copy_list=$3
    
    rm -rf $target_dir
    
    if [[ (! -e $deploy_conf) || (! -e $sed_list) || (! -e $copy_list) ]];then
        echo "ERROR file not exits: $deploy_conf or $sed_list or $copy_list"
        return 1
    fi
    
#genrate files
    while read line
    do
        line=${line%%\#*}			# ignore comment string
        line=${line//[[:space:]]/}		# strip white space                
	   if ((${#line} == 0));then 		# ignore empty
		  continue
	   fi
	   cmd="./generate_conf.sh -f $deploy_conf -g $model_dir/$line -d $target_dir"
	   #echo $cmd
	   eval $cmd
    done < $sed_list
#copy files
    while read line
    do
        line=${line%%\#*}			# ignore comment string        
 	   line=${line//[[:space:]]/}		# strip white space        
	   if ((${#line} == 0));then 		# ignore empty
		  continue
	   fi
	   cmd="./generate_conf.sh -f $deploy_conf -c $model_dir/$line -d $target_dir"
	   #echo $cmd
	   eval $cmd
    done < $copy_list
#do deploy
    ./deploy.sh $deploy_conf $target_dir $action
}

# rm -f ${model_dir}/redis_deploy.conf
# if [[ $action == "uninstall" ]];then
#     cp ${model_dir}/uninstall_redis_deploy.conf ${model_dir}/redis_deploy.conf
# else
#     cp ${model_dir}/install_redis_deploy.conf ${model_dir}/redis_deploy.conf
# fi

cp ${model_dir}/${deply_conf_file} ${model_dir}/${op_log_dir}/${cur_time}_[${action}]_${deply_conf_file}
deploy_one ${model_dir}/${deply_conf_file} ${model_dir}/sed_list ${model_dir}/cp_list

#====================================
${model_dir}/mkall_control.sh
#copy all controller after deploy
if [[ $action == "install" ]];then
    echo -e "\033[1;33m copy all controller after deploy...\033[m"
    cd conf && ./deploy_control.sh ${model_dir} ${deply_conf_file}
fi
