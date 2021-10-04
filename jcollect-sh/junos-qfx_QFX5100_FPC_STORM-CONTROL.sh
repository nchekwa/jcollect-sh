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

exe cprod -A fpc0 -c "show l2 manager mac-table "
exe cprod -A fpc0 -c 'set dcb bc "l2 show"'

exe cprod -A fpc0 -c 'show ifl brief'
exe cprod -A fpc0 -c 'show ifd brief'

exe cprod -A fpc0 -c 'set dcb bc "ps"'
exe cprod -A fpc0 -c 'set dcb bc "phy info"'
exe cprod -A fpc0 -c 'show dcbcm ifd all'

exe cprod -A fpc0 -c 'show storm_cntl profile'
exe cprod -A fpc0 -c 'show storm_cntl profile bindings'

exe cprod -A fpc0 -c 'show halp-pkt pkt-stats'
exe cprod -A fpc0 -c 'show halp-pkt asic-queues'
exe cprod -A fpc0 -c 'show halp-pkt hostpath-cfgs'

exe cprod -A fpc0 -c 'show shim trunk statistics'
exe cprod -A fpc0 -c 'show shim bridge interface'
exe cprod -A fpc0 -c 'show ttp statistics'

exe cprod -A fpc0 -c 'set dcb bc "d chg FP_STORM_CONTROL_METERS_X"'
exe cprod -A fpc0 -c 'set dcb bc "d chg FP_STORM_CONTROL_METERS_Y"'
exe cprod -A fpc0 -c 'set dcb bc "g chg STORM_CONTROL_METER_CONFIG"'
exe cprod -A fpc0 -c 'set dcb bc "g chg STORM_CONTROL_METER_MAPPING"'

exe cprod -A fpc0 -c 'show syslog messages'
