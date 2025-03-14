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

cprod -A fpc0 -c "show dcbcm ifd all"

cprod -A fpc0 -c 'set dcbcm bcmshell "l2 show"'
cprod -A fpc0 -c 'set dcbcm bcmshell "l2 cache show"'
cprod -A fpc0 -c 'set dcbcm bcmshell "multicast show"'
cprod -A fpc0 -c 'set dcbcm bcmshell "l3 multipath show"'
cprod -A fpc0 -c 'set dcbcm bcmshell "l3 l3table show"'
cprod -A fpc0 -c 'set dcbcm bcmshell "l3 defip show"'     #large output
cprod -A fpc0 -c 'set dcbcm bcmshell "l3 egress show"'
cprod -A fpc0 -c 'set dcbcm bcmshell "l3 intf show"' 
cprod -A fpc0 -c 'set dcbcm bcmshell "l3 ip6route show"' 
cprod -A fpc0 -c 'set dcbcm bcmshell "l3 ip6host show"' 

cprod -A fpc0 -c 'set dcbcm bcmshell "d chg L3_ECMP_GROUP"'
cprod -A fpc0 -c 'set dcbcm bcmshell "d chg L3_ECMP"'
cprod -A fpc0 -c 'set dcbcm bcmshell "d chg VLAN_XLATE_1_DOUBLE"'
cprod -A fpc0 -c 'set dcbcm bcmshell "d chg ing_dvp_table"'
cprod -A fpc0 -c 'set dcbcm bcmshell "d chg ing_l3_next_hop"'
cprod -A fpc0 -c 'set dcbcm bcmshell "d chg egr_l3_next_hop"'
cprod -A fpc0 -c 'set dcbcm bcmshell "d chg EGR_L3_INTF"'
cprod -A fpc0 -c 'set dcbcm bcmshell "d chg source_vp"'
cprod -A fpc0 -c 'set dcbcm bcmshell "d chg vfi"'
cprod -A fpc0 -c 'set dcbcm bcmshell "d chg EGR_DVP_ATTRIBUTE"'
cprod -A fpc0 -c 'set dcbcm bcmshell "d chg EGR_IP_TUNNEL"'
cprod -A fpc0 -c 'set dcbcm bcmshell "d chg MY_STATION_TCAM"'
cprod -A fpc0 -c 'set dcbcm bcmshell "d chg MY_STATION_TCAM_2"'
cprod -A fpc0 -c 'set dcbcm bcmshell "d chg mpls_entry_single"'

cprod -A fpc0 -c 'set dcbcm bcmshell "d chg ipmc"'
cprod -A fpc0 -c 'set dcbcm bcmshell "d chg vlan_xlate"'
cprod -A fpc0 -c 'set dcbcm bcmshell "d chg egr_vlan_xlate"'
cprod -A fpc0 -c 'set dcbcm bcmshell "ps"'
cprod -A fpc0 -c 'set dcbcm bcmshell "vlan show"'
cprod -A fpc0 -c 'set dcbcm bcmshell "port xe"'
cprod -A fpc0 -c 'set dcbcm bcmshell "phy info"'
cprod -A fpc0 -c 'set dcbcm bcmshell "soc"'
cprod -A fpc0 -c 'set dcbcm bcmshell "fp show"' 
cprod -A fpc0 -c 'set dcbcm bcmshell "d chg L3_IPMC"' 
cprod -A fpc0 -c 'set dcbcm bcmshell "ipmc table show"'
cprod -A fpc0 -c 'set dcbcm bcmshell "multicast show"'
cprod -A fpc0 -c 'set dcbcm bcmshell "pbmp"' 
cprod -A fpc0 -c 'set dcbcm bcmshell "d efp_tcam"' 
cprod -A fpc0 -c 'set dcbcm bcmshell "d efp_policy_table 1 2"' 
cprod -A fpc0 -c 'set dcbcm bcmshell "list efp_tcam"' 
cprod -A fpc0 -c 'set dcbcm bcmshell "list efp_policy"' 
cprod -A fpc0 -c 'set dcbcm bcmshell "list re"' 
cprod -A fpc0 -c 'set dcbcm bcmshell "d chg EGR_MPLS_VC_AND_SWAP_LABEL_TABLE"'

## run command 6 times (every 10 secends) // 60 sec
for i in 1 2 3 4 5 6
do
cprod -A fpc0 -c 'set dcbcm bcmshell "show c"' 
sleep 10
done



