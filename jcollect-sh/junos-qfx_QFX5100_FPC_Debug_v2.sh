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
