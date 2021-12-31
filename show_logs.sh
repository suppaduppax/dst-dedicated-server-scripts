#!/bin/bash
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "${script_dir}/library.sh"

screen_list=($(screen -list | grep -P -oe "[0-9]+[.]DST_\S+" | grep -P -oe "[^.]+$"))

if [ -z "$screen_list" ]; then
	echo "No clusters currently running"
	exit 1
fi

echo "------------------"
echo "Show Logs"
echo "------------------"
for ((i=0; i<${#screen_list[@]}; i++)); do
	shard_name=$(echo "${screen_list[i]}" | grep -P -oe "(?<=DST_).*")
	echo "$i) ${shard_name}"
done

echo ""
read -p "Which shard do you want to view logs for? " shard_num

re='^[0-9]+$'
if ! [[ $shard_num =~ $re ]]; then
	echo "Invalid number!"
	exit 1
fi

cluster=$(echo "${screen_list[shard_num]}" | grep -P -oe "(?<=DST_)[^@]+")
shard=$(echo "${screen_list[shard_num]}" | grep -P -oe "(?<=@).+")

tail -f "${klei_dst_path}/${cluster}/${shard}/server_log.txt"
