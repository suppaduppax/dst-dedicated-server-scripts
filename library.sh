#!/bin/bash

settings_file="${script_dir}/settings.conf"

print_title () {
	echo "--------------------"
	echo "$1"
	echo "--------------------"
}

get_servers () {
	clusters=("$klei_dst_path"/*)
	for ((i=0; i<${#clusters[@]};i++)); do
		c=$(echo "${clusters[i]}" | grep -o "[^/]*$")
		echo "$c"
	done
	echo ""
}

get_running_server () {
	screen_list=($(screen -list | grep -P -oe "[0-9]+[.]DST_\S+" | grep -P -oe "[^.]+$"))
	echo "${screen_list[0]}" | grep -P -oe "(?<=DST_)[^@]+"
}

is_server_running () {
	if [ -z "$(get_running_server)" ]; then
		false
	else
		true
	fi
}

server_menu_print () {
	servers=($(get_servers))
	for ((i=0; i<${#servers[@]};i++)); do
		echo "$i) ${servers[i]}"
	done
}

server_menu_prompt ()  {
	servers=($(get_servers))
	read -p "$1" cluster_num
	cluster="${servers[cluster_num]}"
	echo "$cluster"
}

confirm () {
	while [ true ]; do
	        read -p "$1 [Y/n]? " -n1 confirm
	        echo ""
	        if [[ "$confirm" == "y" ]] || [ -z "$confirm" ]; then
	                break
	        elif [[ "$confirm" == "n" ]]; then
	                echo "Cancelling..."
	                exit 1
	        fi
	done
}

function trim_log_file() {
	if [ ! -f "$bin_path/$log_file" ]; then
		echo "$bin_path/$log_file not found..."
		return
	fi

	log_lines=$(wc -l < "$bin_path/$log_file")

	if [ -f "$bin_path/$log_file" ] && [ "$log_lines" -gt "$log_file_max_lines" ]; then
		echo "Trimming log file from $log_lines to $log_file_max_lines"
		trim_log=$(tail -n "$log_file_max_lines" "${bin_path}/${log_file}")
		echo "$trim_log" > "${bin_path}/${log_file}"
	else
		echo "Log lines: $log_lines" >> "${bin_path}/$log_file"
	fi

}

function shard_command() {
	cluster=$(get_running_server)
	if [ ! -z "$cluster" ]; then
		echo "Sending '$2' to DST_${cluster}@$1"
		screen -S "DST_${cluster}@$1" -p 0 -X stuff "$2^M"
	fi
}

function server_command() {
	shard_command "Master" "$1"
	shard_command "Caves" "$1"
}

function update_server() {
	log_and_notify "Update scheduled in 20m"
	server_announce "New DST update released! Shutting down server in 15 min" 
	sleep 20
	server_announce "Shutting down server in 5 min" 
	sleep 5
	server_announce "Shutting down server in 1 min" 
	sleep "1m"

	stop_server
	# wait for server to complete shutdown normally
	sleep "20s"

	# force shutdown if it hasnt happened yet
	if is_shard_running "Master"; then
		shard_command "Master" "^C"
		sleep "20s"
	fi
	if is_shard_running "Caves"; then
		shard_command "Caves" "^C"
		sleep "20s"
	fi

	log_and_notify "Updating DST using steamcmd..."
	$steamcmd_path/steamcmd.sh +login anonymous +app_update 343050 +quit
	log_and_notify "Update complete!"
}

function start_shard() {
	log_and_notify "Starting shard: ${cluster}_$1"
	/usr/bin/screen -dmS "DST_${cluster}@$1" /bin/sh -c "${bin_path}/dontstarve_dedicated_server_nullrenderer -console -cluster $cluster -shard $1"
}

function start_server() {
	log_and_notify "Starting $cluster server..."
	start_shard "Master"
	start_shard "Caves"
}

function is_shard_running() {
	check_running=$(screen -S "DST_${cluster}@$1" -Q select .)
	# returns null if screen session was found
	if [ -z "$check_running" ]; then
		true
	else
		false
	fi
}

function stop_server() {
	log_and_notify "Shutting down servers..."
	if is_shard_running "Master"; then
		log_and_notify "Shutting down: ${cluster}_Master"
		server_announce "Shutting down server!"
		shard_command "Master" "c_shutdown()"
	else
		log_and_notify "Shard not running: ${cluster}_Master"
	fi

	if is_shard_running "Caves"; then
		log_and_notify "Shutting down: ${cluster}_Caves"
		server_announce "Shutting down server!"
		shard_command "Caves" "c_shutdown()"
	else
		log_and_notify "Shard not running: ${cluster}_Caves"
	fi
}

function server_announce () {
	server_command "c_announce($1)"
}

function log() {
	echo "[$(date +"%d-%m-%y_%H:%M:%S")] $@" | tee -a "${bin_path}/${log_file}"
}

function log_and_notify() {
	log $@
	if [ ! -z "$discord_webhook" ]; then
		curl -H "Content-Type: application/json" -d "{\"username\": \"DST-Bot\", \"content\": \"$@\"}" "$discord_webhook"
	fi
}

# ensure settings file exists
if [ ! -f "$settings_file" ]; then
	echo "ERROR! Settings file not found at: $settings_file"
	exit 1
fi

# read user defined settings file
while read LINE;
do
#    if [[ "$LINE" =~ ^# || -z "$LINE" ]]; then
        # skip empty lines and ignore spaces and anything that comes after a space
#        continue
#    fi
#    LINE="$(echo "$LINE" | awk '{print $@}')"
	if [ ! -z "$LINE" ] && [[ $line =~ "^[#]"; then
		declare "$LINE";
	fi
done < "$settings_file"

# ensure all variables are set
if [ -z "$klei_dst_path" ]; then
	echo "klei_dst_path variable not set. Check $settings_file."
	exit 1
fi

if [ -z "$dst_bin_path" ]; then
	echo "dst_bin_path variable not set. Check $settings_file."
	exit 1
fi

if [ -z "$steamcmd_path" ]; then
	echo "steamcmd_path variable not set. Check $settings_file."
	exit 1
fi

