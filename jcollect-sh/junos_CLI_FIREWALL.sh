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

# Firewall
exe cli -c 'show interfaces filters | no-more'
exe cli -c 'show firewall detail  | no-more'
exe cli -c 'show firewall log | no-more'
