simple-haproxy-zabbix
=====================

Simple monitoring haproxy stats from zabbix.  
Features:
*  Cache haproxy responses
*  Stats per backend and per server
*  No need to create items in zabbix, uses zabbix discovery features
*  Http Mode Ready, 2xx, 3xx, etc. items ready.  

Install
-------

``sudo mkdir -p /var/lib/zabbix/haproxy``  
Put scripts ``simple_haproxy_stats.sh`` and ``simple_haproxy_discovery.sh``  in ``/var/lib/zabbix/haproxy``  
Check if perms are right `chmod +x /var/lib/zabbix/haproxy/*.sh`   
Modify haproxy socket path in `simple_haproxy_stats.sh`   
Edit line starting with `HAPROXY_SOCKET="/var/lib/haproxy/stats"`  

HAProxy requisites
-------------------

HAProxy 1.6.x and ``socat`` are required.
Autodiscovery feature uses "set server state" command through socket that appears in HAProxy 1.6.     

It's necessary to be able to acces to haproxy socket.  
You will have to add some configuration to haproxy config file (usually haproxy.cfg)

```
global
    stats socket /var/lib/haproxy/stats mode 666 level admin
```  
Notice: mode 666 if zabbix user is running zabbix-agent.



Test
-------
``/var/lib/zabbix/haproxy/simple_haproxy_discovery.sh ``
Should return a json with your fronts and servers.  

 ``/var/lib/zabbix/haproxy/simple_haproxy_stats.sh <backend_name> <server_name> hrsp_2xx``
 Should return the number of 200 OK responses of your backend_name/server_name.    



Greetings 
---------
Thanks to anapsix (https://github.com/anapsix/zabbix-haproxy)   
He made a very complete plugin but sometimes is hard to make it work. 



