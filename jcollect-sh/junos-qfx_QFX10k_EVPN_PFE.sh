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

## run command 6 times (every 10 secends)   // 60 sec
for i in 1 2 3 4 5 6 
do
exe cli -c 'show pfe statistics traffic | no-more'
exe cli -c 'show pfe statistics traffic protocol bfd | no-more'
sleep 10
done

exe cprod -A fpc0 -c "show pechip trapstats verbose"
exe cprod -A fpc0 -c "show shim jnh arp-ndp-nh-table"
exe cprod -A fpc0 -c "show shim jnh vni-table "
exe cprod -A fpc0 -c "show shim jnh vtep-ip-table"
exe cprod -A fpc0 -c "show shim jnh vtep-nh-table"
exe cprod -A fpc0 -c "show shim jnh vtep-table"
exe cprod -A fpc0 -c "show shim jnh vxlan-data"
exe cprod -A fpc0 -c "show shim jnh vxlan-vlan-gl2d-table"
exe cprod -A fpc0 -c "show pechip trapstats verbose"


## run command 6 times (every 10 secends) // 60 sec
for i in 1 2 3 4 5 6
do
exe cprod -A fpc0 -c 'show hw forwarding-drop-cnt'
sleep 10
done

## run command 3 times (every 10 secends) // 30 sec
for i in 1 2 3
do
exe cprod -A fpc0 -c 'show filter hw all non_zero_only 0'
exe cprod -A fpc0 -c 'show filter hw all drop non_zero_only 0'
sleep 10
done

## run command 3 times (every 10 secends) // 30 sec
for i in 1 2 3
do
exe cprod -A fpc0 -c 'show halp-pkt pkt-stats'
sleep 10
done

exe cprod -A fpc0 -c 'show syslog messages'


