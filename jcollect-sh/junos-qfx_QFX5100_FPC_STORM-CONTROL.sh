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

exe cprod -A fpc0 -c "show l2 manager mac-table"
exe cprod -A fpc0 -c "show l2 manager ctxt-history"
exe cprod -A fpc0 -c "show l2 manager ctxt-history mac-address 00:00:5e:00:01:7f"

exe cprod -A fpc0 -c 'show ifl'
exe cprod -A fpc0 -c 'show ifl brief'
exe cprod -A fpc0 -c 'show ifd'
exe cprod -A fpc0 -c 'show ifd brief'

exe cprod -A fpc0 -c 'show bridge-domain'
exe cprod -A fpc0 -c 'show l2 manager bridge-domains'
exe cprod -A fpc0 -c 'show route bridge'

exe cprod -A fpc0 -c 'show dcbcm ifd all'

exe cprod -A fpc0 -c 'show storm_cntl profile'
exe cprod -A fpc0 -c 'show storm_cntl profile bindings'

exe cprod -A fpc0 -c 'show halp-pkt pkt-stats'
exe cprod -A fpc0 -c 'show halp-pkt asic-queues'
exe cprod -A fpc0 -c 'show halp-pkt hostpath-cfgs'

exe cprod -A fpc0 -c 'show ttp statistics'

exe cprod -A fpc0 -c 'show shim mclag-info'
exe cprod -A fpc0 -c 'show shim trunk statistics'
exe cprod -A fpc0 -c 'show shim bridge interface'

exe cprod -A fpc0 -c 'show route ip'
exe cprod -A fpc0 -c 'show heap'

exe cprod -A fpc0 -c 'show nhdb'
exe cprod -A fpc0 -c 'show nhdb management all'

exe cprod -A fpc0 -c 'show pfe manager stat'

exe cprod -A fpc0 -c 'show syslog messages'

## run command 4 times (every 10 secends) // 40 sec
for i in 1 2 3 4
do
exe cprod -A fpc0 -c 'show halp-pkt pkt-stats'
exe cprod -A fpc0 -c 'show ttp stat'
sleep 10
done


exe cprod -A fpc0 -c 'set dcb bc "d chg FP_STORM_CONTROL_METERS_X"'
exe cprod -A fpc0 -c 'set dcb bc "d chg FP_STORM_CONTROL_METERS_Y"'
exe cprod -A fpc0 -c 'set dcb bc "g chg STORM_CONTROL_METER_CONFIG"'
exe cprod -A fpc0 -c 'set dcb bc "g chg STORM_CONTROL_METER_MAPPING"'
exe cprod -A fpc0 -c 'set dcb bc "phy info"'

exe cprod -A fpc0 -c 'set dcb bc "show c cpu"'
exe cprod -A fpc0 -c 'set dcb bc "show c"'
exe cprod -A fpc0 -c 'set dcb bc "ps"'
exe cprod -A fpc0 -c 'set dcb bc "vlan show"'
exe cprod -A fpc0 -c 'set dcb bc "stg show"'
exe cprod -A fpc0 -c 'set dcb bc "l2 show"'
exe cprod -A fpc0 -c 'set dcb bc "trunk show"'
exe cprod -A fpc0 -c 'set dcb bc "getreg chg ing_event_debug"'
exe cprod -A fpc0 -c 'set dcb bc "getreg egr_drop_vector"'
exe cprod -A fpc0 -c 'set dcb bc "fp show"'
exe cprod -A fpc0 -c 'set dcb bc "d chg my_station_tcam"'
exe cprod -A fpc0 -c 'set dcb bc "l3 l3table show"'
exe cprod -A fpc0 -c 'set dcb bc "d chg egress_mask"'
exe cprod -A fpc0 -c 'set dcb bc "d chg my_station_tcam"'
exe cprod -A fpc0 -c 'set dcb bc "d port"'

