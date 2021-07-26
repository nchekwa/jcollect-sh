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

# QoS
exe cli -c 'show policer detail | no-more'
exe cli -c 'show class-of-service | no-more'
exe cli -c 'show class-of-service fabric statistics | no-more'