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
HAPROXY_SOCKET="/var/lib/haproxy/stats" # change
SOCAT_BIN="$(which socat)"

function debug { 
	if [[ $DEBUG == 1 ]]; then
		echo $@
	fi
}

line_number=0
RES=`echo "show servers state" | $SOCAT_BIN $HAPROXY_SOCKET stdio`
#RES=$1
r=""
while IFS='' read -r line || [[ -n "$line" ]] ; do
	((line_number++))
	if [ $line_number -le 2 ]; then 
		continue
	fi		
	debug "$line"	
	
	IFS=' ' read -ra SERVER <<< "$line"	
	r="$r\n\t{\"{#BACKEND_NAME}\":\""${SERVER[1]}"\",\"{#SERVER_NAME}\":\""${SERVER[3]}"\"},"		
done < "$RES"

r="{\"data\":["$r"\n]}"
debug "$r"

printf $r
        