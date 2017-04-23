#!/bin/bash
SCRIPTS_DIR="/var/lib/zabbix/haproxy/"
ZABBIX_USERPARAMETER_DIR="/etc/zabbix/zabbix_agentd.conf.d/"

mkdir -p $SCRIPTS_DIR
cp simple_haproxy_discovery.sh $SCRIPTS_DIR
cp simple_haproxy_stats.sh $SCRIPTS_DIR
chmod +x $SCRIPTS_DIR*.sh
cp userparameter_simple_haproxy.conf $ZABBIX_USERPARAMETER_DIR

echo "Installed"