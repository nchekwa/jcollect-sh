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

# QoS
cli -c 'show policer detail | no-more'
cli -c 'show class-of-service | no-more'
cli -c 'show class-of-service fabric statistics | no-more'