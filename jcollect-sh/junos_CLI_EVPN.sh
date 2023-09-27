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


alias cprod='exe cprod'
alias cli='exe cli'

# EVPN
cli -c 'show route table bgp.evpn.0 | no-more'
cli -c 'show route table :vxlan.inet.0 | no-more'

cli -c 'show ethernet-switching table brief | no-more'

cli -c 'show ethernet-switching vxlan-tunnel-end-point remote | no-more'
cli -c 'show ethernet-switching vxlan-tunnel-end-point source | no-more'

cli -c 'show route forwarding-table table default-switch extensive | no-more'
cli -c 'show route forwarding-table family ethernet-switching | no-more'

cli -c 'show evpn instance extensive | no-more'
cli -c 'show evpn database | no-more'
cli -c 'show evpn database extensive | no-more'
