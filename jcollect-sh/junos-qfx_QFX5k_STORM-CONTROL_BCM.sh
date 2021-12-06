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

exe cprod -A fpc0 -c 'set dcbcm bcmshell "d chg FP_STORM_CONTROL_METERS_X"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "d chg FP_STORM_CONTROL_METERS_Y"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "g chg STORM_CONTROL_METER_CONFIG"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "g chg STORM_CONTROL_METER_MAPPING"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "phy info"'

exe cprod -A fpc0 -c 'set dcbcm bcmshell "show c"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "show c cpu"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "ps"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "vlan show"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "stg show"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "l2 show"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "trunk show"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "getreg chg ing_event_debug"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "getreg egr_drop_vector"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "fp show"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "d chg my_station_tcam"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "l3 l3table show"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "d chg egress_mask"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "d chg my_station_tcam"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "d port"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "show c"'
exe cprod -A fpc0 -c 'set dcbcm bcmshell "show c cpu"'