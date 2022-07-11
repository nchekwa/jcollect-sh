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

## run command 6 times (every 10 secends)   // 60 sec
for i in 1 2 3 4 5 6 
do
exe cli -c 'show pfe statistics traffic | no-more'
exe cli -c 'show pfe statistics traffic protocol bfd | no-more'
sleep 10
done

exe cprod -A fpc0 -c "show ifd brief"
exe cprod -A fpc0 -c "show ifl brief"
exe cprod -A fpc0 -c 'show bridge-domain'
exe cprod -A fpc0 -c 'show pfe-shared-mem ifd_vlan_token-->ifl'
exe cprod -A fpc0 -c 'show pfe-shared-mem ifd_vlan_tag-->ifl'
exe cprod -A fpc0 -c 'show pfe-shared-mem ifd_vlan_tag-->vlan_token'


exe cprod -A fpc0 -c "show shim bridge interface"
exe cprod -A fpc0 -c "show shim virtual bridge-domain"
exe cprod -A fpc0 -c "show shim virtual bridge-domain detail-all"
exe cprod -A fpc0 -c "show shim virtual vport"
exe cprod -A fpc0 -c "show shim virtual vtep-nh"
exe cprod -A fpc0 -c "show shim virtual vtep"
exe cprod -A fpc0 -c "show shim virtual snoop_entry"
exe cprod -A fpc0 -c "show shim virtual tunnel_nh"
exe cprod -A fpc0 -c "show shim virtual error-counters"
exe cprod -A fpc0 -c 'show shim virtual network_ifd_to_egress_mapping'
 
exe cprod -A fpc0 -c 'show nhdb all'
exe cprod -A fpc0 -c 'show nhdb summary'
exe cprod -A fpc0 -c 'show nhdb type unilist'
exe cprod -A fpc0 -c 'show nhdb type unicast'
exe cprod -A fpc0 -c 'show nhdb all extensive'

exe cprod -A fpc0 -c 'show l2 manager vnid'
exe cprod -A fpc0 -c 'show l2 manager bridge-domains'
exe cprod -A fpc0 -c 'show ifd brief'
exe cprod -A fpc0 -c 'show sfp list'
exe cprod -A fpc0 -c 'show filter hw all'
exe cprod -A fpc0 -c 'show filter hw groups'
exe cprod -A fpc0 -c 'show filter hw fp_slice'
exe cprod -A fpc0 -c 'show filter counters'
exe cprod -A fpc0 -c 'show link stats'
exe cprod -A fpc0 -c 'show ppm adjacencies'
exe cprod -A fpc0 -c 'show ppm statistics protocol lacp'
exe cprod -A fpc0 -c 'show threads cpu'
exe cprod -A fpc0 -c 'show filter counters' 
exe cprod -A fpc0 -c 'show route ip hw lpm'


## run command 6 times (every 10 secends) // 60 sec
for i in 1 2 3 4 5 6
do
exe cprod -A fpc0 -c 'show hw forwarding-drop-cnt'
sleep 10
done

## run command 3 times (every 10 secends) // 30 sec
for i in 1 2 3
do
exe cprod -A fpc0 -c 'show filter hw all non_zero_only 0'
exe cprod -A fpc0 -c 'show filter hw all drop non_zero_only 0'
sleep 10
done

## run command 3 times (every 10 secends) // 30 sec
for i in 1 2 3
do
exe cprod -A fpc0 -c 'show halp-pkt pkt-stats'
sleep 10
done

exe cprod -A fpc0 -c 'show syslog messages'


