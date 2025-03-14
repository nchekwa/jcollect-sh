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

# Firewall
cli -c 'show interfaces filters | no-more'
cli -c 'show firewall detail  | no-more'
cli -c 'show firewall log | no-more'
