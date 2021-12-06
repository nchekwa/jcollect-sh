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


exe cprod -A fpc0 -c "show dcbcm ifd all"

exe cprod -A fpc0 -c 'set dcbcm bcmshell "l2 show"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "l2 cache show"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "multicast show"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "l3 multipath show"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "l3 l3table show"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "l3 defip show"'     #large output
exe cprod -A fpc0 -c 'set dcbcm bcmshell "l3 egress show"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "l3 intf show"' 
exe cprod -A fpc0 -c 'set dcbcm bcmshell "l3 ip6route show"' 
exe cprod -A fpc0 -c 'set dcbcm bcmshell "l3 ip6host show"' 

exe cprod -A fpc0 -c 'set dcbcm bcmshell "d chg L3_ECMP_GROUP"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "d chg L3_ECMP"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "d chg VLAN_XLATE_1_DOUBLE"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "d chg ing_dvp_table"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "d chg ing_l3_next_hop"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "d chg egr_l3_next_hop"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "d chg EGR_L3_INTF"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "d chg source_vp"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "d chg vfi"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "d chg EGR_DVP_ATTRIBUTE"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "d chg EGR_IP_TUNNEL"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "d chg MY_STATION_TCAM"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "d chg MY_STATION_TCAM_2"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "d chg mpls_entry_single"'

exe cprod -A fpc0 -c 'set dcbcm bcmshell "d chg ipmc"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "d chg vlan_xlate"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "d chg egr_vlan_xlate"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "ps"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "vlan show"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "port xe"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "phy info"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "soc"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "fp show"' 
exe cprod -A fpc0 -c 'set dcbcm bcmshell "d chg L3_IPMC"' 
exe cprod -A fpc0 -c 'set dcbcm bcmshell "ipmc table show"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "multicast show"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "pbmp"' 
exe cprod -A fpc0 -c 'set dcbcm bcmshell "d efp_tcam"' 
exe cprod -A fpc0 -c 'set dcbcm bcmshell "d efp_policy_table 1 2"' 
exe cprod -A fpc0 -c 'set dcbcm bcmshell "list efp_tcam"' 
exe cprod -A fpc0 -c 'set dcbcm bcmshell "list efp_policy"' 
exe cprod -A fpc0 -c 'set dcbcm bcmshell "list re"' 
exe cprod -A fpc0 -c 'set dcbcm bcmshell "d chg EGR_MPLS_VC_AND_SWAP_LABEL_TABLE"'

## run command 6 times (every 10 secends) // 60 sec
for i in 1 2 3 4 5 6
do
exe cprod -A fpc0 -c 'set dcbcm bcmshell "show c"' 
sleep 10
done



