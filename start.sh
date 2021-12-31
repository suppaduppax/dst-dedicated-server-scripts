#!/bin/bash
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "${script_dir}/library.sh"

running_cluster=$(get_running_server)

if [ ! -z "$running_cluster" ]; then
	echo "There is a cluster already running: ${running_cluster[0]}"
	echo "Stop the running cluster before starting a new one"
	echo ""
	exit 1
fi

print_title "Cluster List"
server_menu_print
echo ""

cluster=$(server_menu_prompt "Select cluster to start: ")
confirm "Start cluster: ${cluster}"

if [ -z "$cluster" ]; then
	echo "Cluster is empty... quitting"
	exit 1
fi

cd "$steamcmd_path"

# update DST in steam
./steamcmd.sh +login anonymous +app_update 343050 +quit

cd "$dst_bin_path"

echo "Starting ${cluster}@Master"
/usr/bin/screen -dmS "DST_${cluster}@Master" /bin/sh -c "./dontstarve_dedicated_server_nullrenderer -console -shard Master -cluster ${cluster}"

echo "Starting ${cluster}@Caves"
/usr/bin/screen -dmS "DST_${cluster}@Caves" /bin/sh -c "./dontstarve_dedicated_server_nullrenderer -console -shard Caves -cluster ${cluster}"
