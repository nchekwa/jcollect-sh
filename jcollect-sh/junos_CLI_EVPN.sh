#!/bin/sh
hostname=$(hostname -s)
exe() {
echo ">======================================================================"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
echo  "$USER@$hostname:~# $@"
echo ""
"$@" 
echo ""; }

# EVPN
exe cli -c 'show route table bgp.evpn.0 | no-more'
exe cli -c 'show route table :vxlan.inet.0 | no-more'

exe cli -c 'show ethernet-switching table brief | no-more'

exe cli -c 'show ethernet-switching vxlan-tunnel-end-point remote | no-more'
exe cli -c 'show ethernet-switching vxlan-tunnel-end-point source | no-more'

exe cli -c 'show route forwarding-table table default-switch extensive | no-more'
exe cli -c 'show route forwarding-table family ethernet-switching | no-more'

exe cli -c 'show evpn instance extensive | no-more'
exe cli -c 'show evpn database | no-more'
exe cli -c 'show evpn database extensive | no-more'
