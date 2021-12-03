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
exe cli -c 'show interfaces mc-ae extensive | no-more'

# ARP
exe cli -c 'show arp no-resolve expiration-time state | no-more'
exe cli -c 'show ethernet-switching table | no-more'
exe cli -c 'show ethernet-switching table extensive | no-more'
exe cli -c 'show ethernet-switching table persistent-learning | no-more'
exe cli -c 'show ethernet-switching flood extensive | no-more'
exe cli -c 'show ethernet-switching debug stats | no-more'
exe cli -c 'show ethernet-switching debug trace | no-more'

# LACP
exe cli -c 'show lacp interfaces | no-more'
exe cli -c 'show lacp interfaces extensive | no-more'
exe cli -c 'show lacp timeouts | no-more'

# VLAN
exe cli -c 'show vlans | no-more'
exe cli -c 'show vlans extensive | no-more'