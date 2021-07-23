echo ">======================================================================"
echo "=== JCollect PFE debug v1"
echo -n "=== Start at: "
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="





echo ">======================================================================"
echo "=== show ukern_trace handles"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c "show ukern_trace handles"

for i in `cprod -c "show ukern_trace handles" -A fpc0 | awk '/^[0-9]/{print $1}'`
do
   echo ">======================================================================"
   echo -n "=== show ukern_trace "
   cprod  -A fpc0 -c "show ukern_trace handles" | egrep "^$i " | awk '{print $1, $2}'
   echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
   echo "======================================================================="
   cprod  -A fpc0 -c "show ukern_trace $i"
done





echo ">======================================================================"
echo "=== show dcbcm ifd all"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c "show dcbcm ifd all"

echo ">======================================================================"
echo "=== sh shim bridge interface"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c "sh shim bridge interface"

echo ">======================================================================"
echo "=== show shim virtual bridge-domain"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c "show shim virtual bridge-domain"

echo ">======================================================================"
echo "=== show shim virtual bridge-domain detail-all"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c "show shim virtual bridge-domain detail-all"

echo ">======================================================================"
echo "=== show shim virtual vport"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c "show shim virtual vport"

echo ">======================================================================"
echo "=== show shim virtual vtep-nh"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c "show shim virtual vtep-nh"

echo ">======================================================================"
echo "=== show shim virtual vtep"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c "show shim virtual vtep"

echo ">======================================================================"
echo "=== show shim virtual snoop_entry"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c "show shim virtual snoop_entry"

echo ">======================================================================"
echo "=== sh shim virtual tunnel_nh"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c "sh shim virtual tunnel_nh"

echo ">======================================================================"
echo "=== show shim virtual error-counters"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c "show shim virtual error-counters"





echo ">======================================================================"
echo "=== l2 show"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c 'set dcb bc "l2 show"'

echo ">======================================================================"
echo "=== multicast show"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c 'set dcb bc "multicast show"'

echo ">======================================================================"
echo "=== l3 multipath show"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c 'set dcb bc "l3 multipath show"'

echo ">======================================================================"
echo "=== l3 l3table show"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c 'set dcb bc "l3 l3table show"'

echo ">======================================================================"
echo "=== l3 defip show"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c 'set dcb bc "l3 defip show"'

echo ">======================================================================"
echo "=== l3 egress show"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c 'set dcb bc "l3 egress show"'





echo ">======================================================================"
echo "=== d chg L3_ECMP_GROUP"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c 'set dcb bc "d chg L3_ECMP_GROUP"'

echo ">======================================================================"
echo "=== d chg L3_ECMP"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c 'set dcb bc "d chg L3_ECMP"'

echo ">======================================================================"
echo "=== d chg VLAN_XLATE_1_DOUBLE"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c 'set dcb bc "d chg VLAN_XLATE_1_DOUBLE"'

echo ">======================================================================"
echo "=== d chg ing_dvp_table"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c 'set dcb bc "d chg ing_dvp_table"'

echo ">======================================================================"
echo "=== d chg ing_l3_next_hop"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c 'set dcb bc "d chg ing_l3_next_hop"'

echo ">======================================================================"
echo "=== d chg egr_l3_next_hop"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c 'set dcb bc "d chg egr_l3_next_hop"'

echo ">======================================================================"
echo "=== d chg EGR_L3_INTF"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c 'set dcb bc "d chg EGR_L3_INTF"'

echo ">======================================================================"
echo "=== d chg source_vp"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c 'set dcb bc "d chg source_vp"'

echo ">======================================================================"
echo "=== d chg vfi"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c 'set dcb bc "d chg vfi"'

echo ">======================================================================"
echo "=== d chg EGR_DVP_ATTRIBUTE"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c 'set dcb bc "d chg EGR_DVP_ATTRIBUTE"'

echo ">======================================================================"
echo "=== d chg EGR_IP_TUNNEL"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c 'set dcb bc "d chg EGR_IP_TUNNEL"'

echo ">======================================================================"
echo "=== d chg my_station_tcam_2"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c 'set dcb bc "d chg my_station_tcam_2"'

echo ">======================================================================"
echo "=== d chg my_station_tcam"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c 'set dcb bc "d chg my_station_tcam"'

echo ">======================================================================"
echo "=== d chg mpls_entry_single"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
cprod -A fpc0 -c 'set dcb bc "d chg mpls_entry_single"'
