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

# L1
exe cli -c 'show interfaces descriptions extensive | no-more'
exe cli -c 'show interfaces terse | no-more'
exe cli -c 'show interfaces diagnostics optics | no-more'
exe cli -c 'show interfaces extensive | no-more'

# ARP
exe cli -c 'show arp no-resolve state | no-more'
exe cli -c 'show ethernet-switching table | no-more'
exe cli -c 'show ethernet-switching table extensive | no-more'
exe cli -c 'show ethernet-switching table persistent-learning | no-more'
exe cli -c 'show ethernet-switching flood extensive | no-more'

