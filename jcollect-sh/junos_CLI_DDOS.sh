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
exe cli -c 'show ddos-protection protocols statistics | no-more'
exe cli -c 'show ddos-protection protocols violations | no-more'

exe cprod -A fpc0 -c "show halp-pkt asic-queues"