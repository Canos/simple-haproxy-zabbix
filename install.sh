#!/bin/bash
mkdir -p /var/lib/zabbix/haproxy
cp *.sh /var/lib/zabbix/haproxy/
cp userparameter_simple_haproxy.conf /etc/zabbix/zabbix_agentd.conf.d/

echo "Installed"