#!/bin/bash

# 
# Usage ./simple_haproxy_discovery.sh 
# 
#  Should return something like this
# {"data":[
#	{"{#BACKEND_NAME}":"web_back","{#SERVER_NAME}":"front01"},
#	{"{#BACKEND_NAME}":"web_back","{#SERVER_NAME}":"front02"}
# ]}
# 
DEBUG=0
LOGFILE="/tmp/simple_haproxy_discovery.log"
HAPROXY_SOCKET="/var/lib/haproxy/stats" # change
SOCAT_BIN="$(which socat)"
CACHE_FILE_NAME="/tmp/simple_haproxy_servers.txt"

function debug { 
	if [[ $DEBUG == 1 ]]; then
		echo $@ >> $LOGFILE
	fi
}


debug "$(date) simple_haproxy_discovery"
line_number=0
echo "show servers state" | $SOCAT_BIN $HAPROXY_SOCKET stdio > $CACHE_FILE_NAME
r=""
while IFS='' read -r line || [[ -n "$line" ]] ; do
	((line_number++))
	if [ $line_number -le 2 ]; then 
		continue
	fi		
	debug "$line"
	
	IFS=' ' read -ra SERVER <<< "$line"
	if [ -z ${SERVER[1]} ]; then
		continue
	fi
	
	r="$r\n\t{\"{#BACKEND_NAME}\":\""${SERVER[1]}"\",\"{#SERVER_NAME}\":\""${SERVER[3]}"\"},"
	debug $r	
done < "$CACHE_FILE_NAME"


r="${r%?}"
r="{\"data\":["$r"\n]}"
debug "$r"

printf $r
        