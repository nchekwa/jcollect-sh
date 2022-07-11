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

# DDOS-PROTECTION
exe cli -c 'show ddos-protection version | no-more'
exe cli -c 'show ddos-protection statistics | no-more'
exe cli -c 'show ddos-protection protocols | no-more'
exe cli -c 'show ddos-protection protocols statistics brief | no-more'
exe cli -c 'show ddos-protection protocols statistics terse | no-more'
exe cli -c 'show ddos-protection protocols statistics | no-more'
exe cli -c 'show ddos-protection protocols violations | no-more'
exe cli -c 'show ddos-protection protocols vxlan violations | no-more'
exe cli -c 'show ddos-protection protocols arp violations | no-more'

exe cprod -A fpc0 -c "show halp-pkt asic-queues"

## run command 6 times (every 10 secends)   // 60 sec
for i in 1 2 3 4 5 6 
do
exe cprod -A fpc0 -c "show halp-pkt pkt-stats"
sleep 10
done
