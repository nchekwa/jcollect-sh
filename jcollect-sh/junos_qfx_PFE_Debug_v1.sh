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

exe cprod -A fpc0 -c "show ukern_trace handles"
for i in `cprod  -A fpc0 -c "show ukern_trace handles" | egrep "^[0-9].* " | awk '{print $1 ":" $2}'`
do
   trace_id=${i%:*}
   trace_name=${i#*:}
   echo ">======================================================================"   
   echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
   echo "======================================================================="
   echo  "$USER@$hostname:~# cprod -A fpc0 -c \"show ukern_trace $trace_id\"     [$trace_name]"
   cprod  -A fpc0 -c "show ukern_trace $trace_id"
   echo ""
done

exe cprod -A fpc0 -c "show dcbcm ifd all"
exe cprod -A fpc0 -c "sh shim bridge interface"
exe cprod -A fpc0 -c "show shim virtual bridge-domain"
exe cprod -A fpc0 -c "show shim virtual bridge-domain detail-all"
exe cprod -A fpc0 -c "show shim virtual vport"
exe cprod -A fpc0 -c "show shim virtual vtep-nh"
exe cprod -A fpc0 -c "show shim virtual vtep"
exe cprod -A fpc0 -c "show shim virtual snoop_entry"
exe cprod -A fpc0 -c "sh shim virtual tunnel_nh"
exe cprod -A fpc0 -c "show shim virtual error-counters"
 
exe cprod -A fpc0 -c 'set dcb bc "l2 show"'
exe cprod -A fpc0 -c 'set dcb bc "multicast show"'
exe cprod -A fpc0 -c 'set dcb bc "l3 multipath show"'
exe cprod -A fpc0 -c 'set dcb bc "l3 l3table show"'
exe cprod -A fpc0 -c 'set dcb bc "l3 defip show"'
exe cprod -A fpc0 -c 'set dcb bc "l3 egress show"'
 
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
exe cprod -A fpc0 -c 'set dcb bc "d chg my_station_tcam_2"'
exe cprod -A fpc0 -c 'set dcb bc "d chg my_station_tcam"'
exe cprod -A fpc0 -c 'set dcb bc "d chg mpls_entry_single"'
