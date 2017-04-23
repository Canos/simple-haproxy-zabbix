simple-haproxy-zabbix
=====================

Simple monitoring haproxy stats from zabbix
Features:
*  Cache haproxy responses
*  Stats per backend and per server
*  No need to create items in zabbix, uses zabbix discovery features
*  Http Mode Ready, 2xx, 3xx, etc. items ready.  

Install
-------

``mkdir -p /var/lib/zabbix/haproxy`` 
Place scripts ``simple_haproxy_stats.sh`` and ``simple_haproxy_discovery.sh``  in ``/var/lib/zabbix/haproxy``  
Check if `chmod +x /var/lib/zabbix/haproxy/simple_haproxy_stats.sh`   
Modify haproxy socket path in `simple_haproxy_stats.sh`   
Edit line starting with `HAPROXY_SOCKET="/var/lib/haproxy/stats"`  

HAProxy config
--------------

It's necessary to be able to acces to haproxy socket.  
You will have to add some configuration to haproxy config file (usually haproxy.cfg)

```
global
    stats socket /var/lib/haproxy/stats mode 666 level admin
```

Test
-------


Greetings 
---------
Thanks to anapsix (https://github.com/anapsix/zabbix-haproxy)   
He made a very complete plugin but sometimes is hard to make it work. 



