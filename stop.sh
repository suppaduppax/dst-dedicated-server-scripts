#!/bin/bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "${script_dir}/library.sh"

if ! is_server_running; then
	echo "No clusters currently running"
	exit 1
fi

cluster_name=$(get_running_server)
confirm "Stop cluster: ${cluster_name}"
server_command "c_shutdown()"
