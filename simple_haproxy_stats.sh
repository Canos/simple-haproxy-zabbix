#!/bin/bash

# 
# Usage ./simple_haproxy_stats.sh <backend> <server> <metric> <stats_file>
# 
DEBUG=0
HAPROXY_SOCKET="/var/lib/haproxy/stats" # change 
BACKEND=$1
SERVER=$2
METRIC=$3
SOCAT_BIN="$(which socat)"
CACHE_EXPIRATION_TIME_SECONDS=60
CACHE_FILE="/tmp/simple_haproxy_stats.txt"

function debug { 
	if [[ $DEBUG == 1 ]]; then
		echo $@
	fi
}
function generate_cache_file {
	echo "show stat" | $SOCAT_BIN $HAPROXY_SOCKET stdio > $CACHE_FILE
}
function get_stat_from_cache() {
	RES=`grep -i $BACKEND,$SERVER $CACHE_FILE | awk -F, -v column=$1 '{print $column}'`
	debug "$BACKEND / $SERVER $METRIC $1 = $RES"
	echo $RES
}

# create if doesnt exists
if [ ! -e $CACHE_FILE ]; then
	debug "Creating cache file"
	generate_cache_file
fi

# recreate cache file if expired
TIMEFLM=`stat -c %Y $CACHE_FILE`
TIMENOW=`date +%s`
DIFF=$(($TIMENOW - $TIMEFLM))
debug "$TIMENOW - $TIMEFLM = $DIFF > $CACHE_EXPIRATION_TIME_SECONDS" 
if [ $DIFF -gt $CACHE_EXPIRATION_TIME_SECONDS ]; then
	debug "Expired cache file"
	rm -f $CACHEFILE
	generate_cache_file
fi

# Thanks to anapsix (https://github.com/anapsix/zabbix-haproxy)
MAP="
1:pxname:@
2:svname:@
3:qcur:9999999999
4:qmax:0
5:scur:9999999999
6:smax:0
7:slim:0
8:stot:@
9:bin:9999999999
10:bout:9999999999
11:dreq:9999999999
12:dresp:9999999999
13:ereq:9999999999
14:econ:9999999999
15:eresp:9999999999
16:wretr:9999999999
17:wredis:9999999999
18:status:UNK
19:weight:9999999999
20:act:9999999999
21:bck:9999999999
22:chkfail:9999999999
23:chkdown:9999999999
24:lastchg:9999999999
25:downtime:0
26:qlimit:0
27:pid:@
28:iid:@
29:sid:@
30:throttle:9999999999
31:lbtot:9999999999
32:tracked:9999999999
33:type:9999999999
34:rate:9999999999
35:rate_lim:@
36:rate_max:@
37:check_status:@
38:check_code:@
39:check_duration:9999999999
40:hrsp_1xx:@
41:hrsp_2xx:@
42:hrsp_3xx:@
43:hrsp_4xx:@
44:hrsp_5xx:@
45:hrsp_other:@
46:hanafail:@
47:req_rate:9999999999
48:req_rate_max:@
49:req_tot:9999999999
50:cli_abrt:9999999999
51:srv_abrt:9999999999
52:comp_in:0
53:comp_out:0
54:comp_byp:0
55:comp_rsp:0
56:lastsess:9999999999
57:last_chk:@
58:last_agt:@
59:qtime:0
60:ctime:0
61:rtime:0
62:ttime:0
"

STAT=$(echo -e "$MAP" | grep :${METRIC}:)
IDX=${STAT%%:*}
get_stat_from_cache $IDX
