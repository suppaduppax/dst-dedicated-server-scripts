#!/bin/bash
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "${script_dir}/library.sh"

klei_dst_path="/home/alvin/.klei/DoNotStarveTogether"

print_title "Servers List"
servers=($(get_servers))
running=$(get_running_server)

for server_name in ${servers[@]}; do
	if [[ "$server_name" == "$running" ]]; then
		echo "$server_name [running]"
	else
		echo "$server_name"
	fi
done
echo
