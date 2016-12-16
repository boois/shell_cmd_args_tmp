#!/usr/bin/env bash
# 萧鸣 boois@qq.com
arg_idx=0 # 设定一个索引变量
arg_arr=() # 设定变量数组
for x in "$@" # 遍历所有参数
do
	arg_idx=`expr ${arg_idx} + 1` # 当前索引+1
	arg=`eval echo '$''{'"${arg_idx}"'}'` # 获取当前参数
	arg_is_cmd=0 # 当前参数是否是命令参数
	next_arg_idx=`expr ${arg_idx} + 1` # 当前索引+1
	next_arg=`eval echo '$''{'"${next_arg_idx}"'}'` # 获取下一个参数
	next_arg_is_cmd=0 # 下一个参数是否是命令参数
	# 检查当前参数是否是-或者--开头
	if [ "${arg:0:2}" = "--" ];then arg="${arg:2}"; arg_is_cmd=1; elif [ "${arg:0:1}" = "-" ];then arg="${arg:1}"; arg_is_cmd=1; fi
	# 检查下一个参数是否是-或者--开头
	if [ "${next_arg:0:2}" = "--" ];then next_arg="${next_arg:2}"; next_arg_is_cmd=1; elif [ "${next_arg:0:1}" = "-" ];then next_arg="${next_arg:1}"; next_arg_is_cmd=1; fi
	# 如果当前参数是命令参数
	if [ "${arg_is_cmd}" -eq 1 ];then
		if [ ! "$next_arg" ];then next_arg=$arg;fi # 如果下一个参数为空,则设为当前命令
		# 如果是一个命令的话,并且检查下一个参数是不是命令,如果不是的话就是当前命令的值
		if [ "${next_arg_is_cmd}" -eq 0 ];then
			# 如果是最后一个则赋值给自己否则使用下一个参数
			if [ ${arg_idx} -eq $# ];then eval 'arg_'"${arg}="'$'"arg";else eval 'arg_'"${arg}="'$'"next_arg";fi
		else
			eval 'arg_'"${arg}="'$'"arg";
		fi
		arg_arr[$arg_idx]="arg_${arg}";
	fi
done

# 这里直接通过上面的变量来判定是否有命令输入,$arg_a={val} => -a {val},如果命令后面没有跟值的话,值等于命令自己的名称
# 下面是help命令的示范: 输入 -h 或 --h后可以打印出帮助文档,可以根据按需书写命令行帮助说明
if [ "$arg_h" ];then
	printf "description: this cmd's description\n"
	printf "  %-5s %-20s\n" "-h" "help"
	printf "  %-5s %-20s\n" "-a" "other desciption"
fi

# 下面是通过遍历数组来依次访问所有参数
for x in ${arg_arr[@]}
do
	eval echo "${x}="'$'"${x}"
done
