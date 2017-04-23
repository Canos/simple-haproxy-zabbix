#!/bin/bash

# 
# Usage ./simple_haproxy_discovery.sh <[BACKENDS|SERVERS]>
# 
DEBUG=1
HAPROXY_SOCKET="/var/lib/haproxy/stats" # change
SOCAT_BIN="$(which socat)"

function debug { 
	if [[ $DEBUG == 1 ]]; then
		echo $@
	fi
}

line_number=0
RES=`echo "show servers state" | $SOCAT_BIN $HAPROXY_SOCKET stdio`
while IFS='' read -r line || [[ -n "$line" ]] && ! $not_finished ; do
	((line_number++))
	if [ $line_number -eq 1 ]; then 
		continue
	fi
		
	debug "$line_number $line"	
	
	IFS=' ' read -ra SERVER <<< "$line"
	
	
	
	#for backend in $(get_stats | grep BACKEND | cut -d, -f1 | uniq); do
     #for server in $(get_stats | grep "^${backend}," | grep -v BACKEND | cut -d, -f2); do
      #serverlist="$serverlist,\n"'\t\t{\n\t\t\t"{#BACKEND_NAME}":"'$backend'",\n\t\t\t"{#SERVER_NAME}":"'$server'"}'
	
	
done < "$RES"
# echo -e '{\n\t"data":[\n'${serverlist#,}']}'
        