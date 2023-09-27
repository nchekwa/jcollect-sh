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

## run command 6 times (every 10 secends)   // 60 sec
for i in 1 2 3 4 5 6 
do
cli -c 'show pfe statistics traffic | no-more'
cli -c 'show pfe statistics traffic protocol bfd | no-more'
sleep 10
done

cprod -A fpc0 -c "show ifd brief"
cprod -A fpc0 -c "show ifl brief"
cprod -A fpc0 -c 'show bridge-domain'
cprod -A fpc0 -c 'show pfe-shared-mem ifd_vlan_token-->ifl'
cprod -A fpc0 -c 'show pfe-shared-mem ifd_vlan_tag-->ifl'
cprod -A fpc0 -c 'show pfe-shared-mem ifd_vlan_tag-->vlan_token'


cprod -A fpc0 -c "show shim bridge interface"
cprod -A fpc0 -c "show shim virtual bridge-domain"
cprod -A fpc0 -c "show shim virtual bridge-domain detail-all"
cprod -A fpc0 -c "show shim virtual vport"
cprod -A fpc0 -c "show shim virtual vtep-nh"
cprod -A fpc0 -c "show shim virtual vtep"
cprod -A fpc0 -c "show shim virtual snoop_entry"
cprod -A fpc0 -c "show shim virtual tunnel_nh"
cprod -A fpc0 -c "show shim virtual error-counters"
cprod -A fpc0 -c 'show shim virtual network_ifd_to_egress_mapping'
 
cprod -A fpc0 -c 'show nhdb all'
cprod -A fpc0 -c 'show nhdb summary'
cprod -A fpc0 -c 'show nhdb type unilist'
cprod -A fpc0 -c 'show nhdb type unicast'
cprod -A fpc0 -c 'show nhdb all extensive'

cprod -A fpc0 -c 'show l2 manager vnid'
cprod -A fpc0 -c 'show l2 manager bridge-domains'
cprod -A fpc0 -c 'show ifd brief'
cprod -A fpc0 -c 'show sfp list'
cprod -A fpc0 -c 'show filter hw all'
cprod -A fpc0 -c 'show filter hw groups'
cprod -A fpc0 -c 'show filter hw fp_slice'
cprod -A fpc0 -c 'show filter counters'
cprod -A fpc0 -c 'show link stats'
cprod -A fpc0 -c 'show ppm adjacencies'
cprod -A fpc0 -c 'show ppm statistics protocol lacp'
cprod -A fpc0 -c 'show threads cpu'
cprod -A fpc0 -c 'show filter counters' 
cprod -A fpc0 -c 'show route ip hw lpm'


## run command 6 times (every 10 secends) // 60 sec
for i in 1 2 3 4 5 6
do
cprod -A fpc0 -c 'show hw forwarding-drop-cnt'
sleep 10
done

## run command 3 times (every 10 secends) // 30 sec
for i in 1 2 3
do
cprod -A fpc0 -c 'show filter hw all non_zero_only 0'
cprod -A fpc0 -c 'show filter hw all drop non_zero_only 0'
sleep 10
done

## run command 3 times (every 10 secends) // 30 sec
for i in 1 2 3
do
cprod -A fpc0 -c 'show halp-pkt pkt-stats'
sleep 10
done

cprod -A fpc0 -c 'show syslog messages'


