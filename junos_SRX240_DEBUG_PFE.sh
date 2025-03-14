#!/bin/sh
hostname=$(hostname -s)
exe() {
echo ">======================================================================"
echo "=== $USER@$hostname:~# $@"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
echo ""
"$@" 
echo ""; }

alias cli='exe cli'

cli -c 'request pfe execute command "show services mum" target fwdd'
cli -c 'request pfe execute command "show usp nat source-pool statistics" target fwdd' 
cli -c 'request pfe execute command "show usp nat counter" target fwdd' 
cli -c 'request pfe execute command "show usp nat persistent-nat-table" target fwdd' 
cli -c 'request pfe execute command "show usp nat translation-context" target fwdd'
cli -c 'request pfe execute command "show usp asl stats all" target fwdd' 
cli -c 'request pfe execute command "set jsf trace per-plugin-trace disable" target fwdd' 
cli -c 'request pfe execute command "show usp jsf counters h323-alg" target fwdd'
cli -c 'request pfe execute command "show usp jsf counters ras-alg" target fwdd'
cli -c 'request pfe execute command "show usp jsf tcpstats" target fwdd' 
cli -c 'request pfe execute command "show usp jsf plugin-list" target fwdd' 
cli -c 'request pfe execute command "show usp jsf tcp stats all" target fwdd' 
cli -c 'request pfe execute command "show usp jsf plugins" target fwdd' 
cli -c 'request pfe execute command "show usp jsf jbuf_pool stats" target fwdd' 
cli -c 'request pfe execute command "show usp jsf counters" target fwdd' 
cli -c 'request pfe execute command "show usp jsf tcpconfig" target fwdd' 
cli -c 'request pfe execute command "show usp algs jsf_alg_mgr stats" target fwdd' 
cli -c 'request pfe execute command "show usp flow counters all" target fwdd' 
cli -c 'request pfe execute command "show usp memory segment heap modules" target fwdd'
cli -c 'request pfe execute command "show octeon memory" target fwdd' 
cli -c 'request pfe execute command "show arena" target fwdd' 
cli -c 'request pfe execute command "show dpq stat" target fwdd' 
cli -c 'request pfe execute command "show dpq pot" target fwdd'
cli -c 'request pfe execute command "show usp plugins" target fwdd'
cli -c 'request pfe execute command "show usp gate statistics" target fwdd'
