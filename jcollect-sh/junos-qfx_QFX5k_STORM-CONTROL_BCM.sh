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

cprod -A fpc0 -c 'set dcbcm bcmshell "d chg FP_STORM_CONTROL_METERS_X"'
cprod -A fpc0 -c 'set dcbcm bcmshell "d chg FP_STORM_CONTROL_METERS_Y"'
cprod -A fpc0 -c 'set dcbcm bcmshell "g chg STORM_CONTROL_METER_CONFIG"'
cprod -A fpc0 -c 'set dcbcm bcmshell "g chg STORM_CONTROL_METER_MAPPING"'
cprod -A fpc0 -c 'set dcbcm bcmshell "phy info"'

cprod -A fpc0 -c 'set dcbcm bcmshell "show c"'
cprod -A fpc0 -c 'set dcbcm bcmshell "show c cpu"'
cprod -A fpc0 -c 'set dcbcm bcmshell "ps"'
cprod -A fpc0 -c 'set dcbcm bcmshell "vlan show"'
cprod -A fpc0 -c 'set dcbcm bcmshell "stg show"'
cprod -A fpc0 -c 'set dcbcm bcmshell "l2 show"'
cprod -A fpc0 -c 'set dcbcm bcmshell "trunk show"'
cprod -A fpc0 -c 'set dcbcm bcmshell "getreg chg ing_event_debug"'
cprod -A fpc0 -c 'set dcbcm bcmshell "getreg egr_drop_vector"'
cprod -A fpc0 -c 'set dcbcm bcmshell "fp show"'
cprod -A fpc0 -c 'set dcbcm bcmshell "d chg my_station_tcam"'
cprod -A fpc0 -c 'set dcbcm bcmshell "l3 l3table show"'
cprod -A fpc0 -c 'set dcbcm bcmshell "d chg egress_mask"'
cprod -A fpc0 -c 'set dcbcm bcmshell "d chg my_station_tcam"'
cprod -A fpc0 -c 'set dcbcm bcmshell "d port"'
cprod -A fpc0 -c 'set dcbcm bcmshell "show c"'
cprod -A fpc0 -c 'set dcbcm bcmshell "show c cpu"'