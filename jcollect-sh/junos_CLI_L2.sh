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

# LLDP
exe cli -c 'show lldp detail | no-more'
exe cli -c 'show lldp statistics | no-more'
exe cli -c 'show lldp neighbors | no-more'
exe cli -c 'show lldp neighbors detail | no-more'

# ARP
exe cli -c 'show arp no-resolve expiration-time state | no-more'
exe cli -c 'show arp state no-resolve | no-more'
exe cli -c 'show ethernet-switching table | no-more'
exe cli -c 'show ethernet-switching table extensive | no-more'
exe cli -c 'show ethernet-switching table persistent-learning | no-more'
exe cli -c 'show ethernet-switching mac-ip-table extensive | no-more'
exe cli -c 'show ethernet-switching flood extensive | no-more'
exe cli -c 'show ethernet-switching debug stats | no-more'
exe cli -c 'show ethernet-switching debug trace | no-more'
exe cli -c 'show ethernet-switching evpn arp-table extensive | no-more'
exe cli -c 'show ethernet-switching mac-learning-log | no-more'
exe cli -c 'show ethernet-switching context-history | no-more'

exe cli -c 'show ethernet-switching vxlan-tunnel-end-point source | no-more'
exe cli -c 'show ethernet-switching vxlan-tunnel-end-point remote summary | no-more'
exe cli -c 'show ethernet-switching vxlan-tunnel-end-point remote | no-more'
exe cli -c 'show ethernet-switching vxlan-tunnel-end-point remote mac-table  | no-more'
exe cli -c 'show ethernet-switching vxlan-tunnel-end-point esi | no-more'

# LACP
exe cli -c 'show lacp interfaces | no-more'
exe cli -c 'show lacp interfaces extensive | no-more'
exe cli -c 'show lacp timeouts | no-more'

# VLAN
exe cli -c 'show vlans | no-more'
exe cli -c 'show vlans extensive | no-more'

# STP
exe cli -c 'show spanning-tree bridge | no-more'
exe cli -c 'show spanning-tree interface | no-more'
exe cli -c 'show spanning-tree interface detail | no-more'
exe cli -c 'show spanning-tree statistics interface detail | no-more'
