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

# FORWARDING TABLE
exe cli -c 'show route forwarding-table summary | no-more'
exe cli -c 'show route forwarding-table family inet | no-more'
exe cli -c 'show route forwarding-table family inet6 | no-more'
exe cli -c 'show route forwarding-table multicast extensive | no-more'

exe cli -c 'show route forwarding-table | no-more'   #large output   

