#!/bin/bash

# quit if no clusters are running...
if ! is_server_running; then
	echo "No servers are running..."
	exit 1
fi

log_file="update.log"
log_file_max_lines=500
release_file="update-last-release.txt"
builds_url="https://s3.amazonaws.com/dstbuilds/builds.json"

current_release=$(curl -s $builds_url | jq ".release | last" | grep -oe '[^"]*' )

if [ -z current_release ]; then
	log_and_notify "[Error] Could not get current release! Check forum_html link for errors."
	exit 1;
fi

trap trim_log_file EXIT

# get the last release since update
if [ -f "${bin_path}/$release_file" ]; then
	last_release=$(cat "${bin_path}/$release_file")
fi

if [ -z "$last_release" ]; then
	log_and_notify "Unable to fetch release of running server from $release_file! Attempting update..."
	update_server

	# write update file
	echo "$current_release" > "${bin_path}/$release_file"

	start_server
elif [ "$current_release" -gt "$last_release" ]; then
	log_and_notify "New release detected!"
	log_and_notify "Updating from $last_release to $current_release..."
	update_server

	# write update file
	echo "$current_release" > "${bin_path}/$release_file"

	start_server
else
	# do not send discord msg with this
	log "Server is already up to date (release: ${last_release})"
fi

