#!/bin/sh
hostname=$(hostname -s)
exe() {
echo ">======================================================================"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
echo  "$USER@$hostname:~# $@"
echo ""
"$@" 
echo ""; }

exe cli -c 'request pfe execute command "show services mum" target fwdd'
exe cli -c 'request pfe execute command "show usp nat source-pool statistics" target fwdd' 
exe cli -c 'request pfe execute command "show usp nat counter" target fwdd' 
exe cli -c 'request pfe execute command "show usp nat persistent-nat-table" target fwdd' 
exe cli -c 'request pfe execute command "show usp nat translation-context" target fwdd'
exe cli -c 'request pfe execute command "show usp asl stats all" target fwdd' 
exe cli -c 'request pfe execute command "set jsf trace per-plugin-trace disable" target fwdd' 
exe cli -c 'request pfe execute command "show usp jsf counters h323-alg" target fwdd'
exe cli -c 'request pfe execute command "show usp jsf counters ras-alg" target fwdd'
exe cli -c 'request pfe execute command "show usp jsf tcpstats" target fwdd' 
exe cli -c 'request pfe execute command "show usp jsf plugin-list" target fwdd' 
exe cli -c 'request pfe execute command "show usp jsf tcp stats all" target fwdd' 
exe cli -c 'request pfe execute command "show usp jsf plugins" target fwdd' 
exe cli -c 'request pfe execute command "show usp jsf jbuf_pool stats" target fwdd' 
exe cli -c 'request pfe execute command "show usp jsf counters" target fwdd' 
exe cli -c 'request pfe execute command "show usp jsf tcpconfig" target fwdd' 
exe cli -c 'request pfe execute command "show usp algs jsf_alg_mgr stats" target fwdd' 
exe cli -c 'request pfe execute command "show usp flow counters all" target fwdd' 
exe cli -c 'request pfe execute command "show usp memory segment heap modules" target fwdd'
exe cli -c 'request pfe execute command "show octeon memory" target fwdd' 
exe cli -c 'request pfe execute command "show arena" target fwdd' 
exe cli -c 'request pfe execute command "show dpq stat" target fwdd' 
exe cli -c 'request pfe execute command "show dpq pot" target fwdd'
exe cli -c 'request pfe execute command "show usp plugins" target fwdd'
exe cli -c 'request pfe execute command "show usp gate statistics" target fwdd'
