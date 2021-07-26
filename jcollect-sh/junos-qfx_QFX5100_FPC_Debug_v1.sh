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

exe cprod -A fpc0 -c "show ukern_trace handles"
for i in `cprod  -A fpc0 -c "show ukern_trace handles" | egrep "^[0-9].* " | awk '{print $1 ":" $2}'`
do
   trace_id=${i%:*}
   trace_name=${i#*:}
   echo ">======================================================================"
   echo  "=== $USER@$hostname:~# cprod -A fpc0 -c \"show ukern_trace $trace_id\"     [$trace_name]"
   echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
   echo "======================================================================="
   echo ""
   cprod  -A fpc0 -c "show ukern_trace $trace_id"
   echo ""
done


exe cprod -A fpc0 -c "show ifd brief"
exe cprod -A fpc0 -c "show ifl brief"
exe cprod -A fpc0 -c 'show bridge-domain'
exe cprod -A fpc0 -c 'show pfe-shared-mem ifd_vlan_token-->ifl'
exe cprod -A fpc0 -c 'show pfe-shared-mem ifd_vlan_tag-->ifl'
exe cprod -A fpc0 -c 'show pfe-shared-mem ifd_vlan_tag-->vlan_token'

exe cprod -A fpc0 -c "show dcbcm ifd all"
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

exe cprod -A fpc0 -c 'set dcb bc "l2 show"'
exe cprod -A fpc0 -c 'set dcb bc "l2 cache show"'
exe cprod -A fpc0 -c 'set dcb bc "multicast show"'
exe cprod -A fpc0 -c 'set dcb bc "l3 multipath show"'
exe cprod -A fpc0 -c 'set dcb bc "l3 l3table show"'
exe cprod -A fpc0 -c 'set dcb bc "l3 defip show"'     #large output
exe cprod -A fpc0 -c 'set dcb bc "l3 egress show"'
exe cprod -A fpc0 -c 'set dcb bc "l3 intf show"' 
exe cprod -A fpc0 -c 'set dcb bc "l3 ip6route show"' 
exe cprod -A fpc0 -c 'set dcb bc "l3 ip6host show"' 

exe cprod -A fpc0 -c 'set dcb bc "d chg L3_ECMP_GROUP"'
exe cprod -A fpc0 -c 'set dcb bc "d chg L3_ECMP"'
exe cprod -A fpc0 -c 'set dcb bc "d chg VLAN_XLATE_1_DOUBLE"'
exe cprod -A fpc0 -c 'set dcb bc "d chg ing_dvp_table"'
exe cprod -A fpc0 -c 'set dcb bc "d chg ing_l3_next_hop"'
exe cprod -A fpc0 -c 'set dcb bc "d chg egr_l3_next_hop"'
exe cprod -A fpc0 -c 'set dcb bc "d chg EGR_L3_INTF"'
exe cprod -A fpc0 -c 'set dcb bc "d chg source_vp"'
exe cprod -A fpc0 -c 'set dcb bc "d chg vfi"'
exe cprod -A fpc0 -c 'set dcb bc "d chg EGR_DVP_ATTRIBUTE"'
exe cprod -A fpc0 -c 'set dcb bc "d chg EGR_IP_TUNNEL"'
exe cprod -A fpc0 -c 'set dcb bc "d chg MY_STATION_TCAM"'
exe cprod -A fpc0 -c 'set dcb bc "d chg MY_STATION_TCAM_2"'
exe cprod -A fpc0 -c 'set dcb bc "d chg mpls_entry_single"'


exe cprod -A fpc0 -c 'set dcb bc "d chg ipmc"'
exe cprod -A fpc0 -c 'set dcb bc "d chg vlan_xlate"'
exe cprod -A fpc0 -c 'set dcb bc "d chg egr_vlan_xlate"'
exe cprod -A fpc0 -c 'set dcb bc "ps"'
exe cprod -A fpc0 -c 'set dcb bc "vlan show"'
exe cprod -A fpc0 -c 'set dcb bc "port xe"'
exe cprod -A fpc0 -c 'set dcb bc "phy info"'
exe cprod -A fpc0 -c 'set dcb bc "soc"'
exe cprod -A fpc0 -c 'set dcb bc "fp show"' 
exe cprod -A fpc0 -c 'set dcb bc "d chg L3_IPMC"' 
exe cprod -A fpc0 -c 'set dcb bc "ipmc table show"'
exe cprod -A fpc0 -c 'set dcb bc "multicast show"'
exe cprod -A fpc0 -c 'set dcb bc "pbmp"' 
exe cprod -A fpc0 -c 'set dcb bc "d efp_tcam"' 
exe cprod -A fpc0 -c 'set dcb bc "d efp_policy_table 1 2"' 
exe cprod -A fpc0 -c 'set dcb bc "list efp_tcam"' 
exe cprod -A fpc0 -c 'set dcb bc "list efp_policy"' 
exe cprod -A fpc0 -c 'set dcb bc "list re"' 
exe cprod -A fpc0 -c 'set dcb bc "d chg EGR_MPLS_VC_AND_SWAP_LABEL_TABLE"'
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
exe cprod -A fpc0 -c 'set dcb bc "show c"' 
sleep 10
done

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