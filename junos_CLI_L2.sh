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

# L1
cli -c 'show interfaces descriptions extensive | no-more'
cli -c 'show interfaces terse | no-more'
cli -c 'show interfaces diagnostics optics | no-more'
cli -c 'show interfaces extensive | no-more'
cli -c 'show interfaces mc-ae extensive | no-more'

# LLDP
cli -c 'show lldp detail | no-more'
cli -c 'show lldp statistics | no-more'
cli -c 'show lldp neighbors | no-more'
cli -c 'show lldp neighbors detail | no-more'

# ARP
cli -c 'show arp no-resolve expiration-time state | no-more'
cli -c 'show arp state no-resolve | no-more'
cli -c 'show ethernet-switching table | no-more'
cli -c 'show ethernet-switching table extensive | no-more'
cli -c 'show ethernet-switching table persistent-learning | no-more'
cli -c 'show ethernet-switching mac-ip-table extensive | no-more'
cli -c 'show ethernet-switching flood extensive | no-more'
cli -c 'show ethernet-switching debug stats | no-more'
cli -c 'show ethernet-switching debug trace | no-more'
cli -c 'show ethernet-switching evpn arp-table extensive | no-more'
cli -c 'show ethernet-switching mac-learning-log | no-more'
cli -c 'show ethernet-switching context-history | no-more'

cli -c 'show ethernet-switching vxlan-tunnel-end-point source | no-more'
cli -c 'show ethernet-switching vxlan-tunnel-end-point remote summary | no-more'
cli -c 'show ethernet-switching vxlan-tunnel-end-point remote | no-more'
cli -c 'show ethernet-switching vxlan-tunnel-end-point remote mac-table  | no-more'
cli -c 'show ethernet-switching vxlan-tunnel-end-point esi | no-more'

# LACP
cli -c 'show lacp interfaces | no-more'
cli -c 'show lacp interfaces extensive | no-more'
cli -c 'show lacp timeouts | no-more'

# VLAN
cli -c 'show vlans | no-more'
cli -c 'show vlans extensive | no-more'

# STP
cli -c 'show spanning-tree bridge | no-more'
cli -c 'show spanning-tree interface | no-more'
cli -c 'show spanning-tree interface detail | no-more'
cli -c 'show spanning-tree statistics interface detail | no-more'
