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


exe cprod -A fpc0 -c 'show ppm statistics protocol lacp'
exe cprod -A fpc0 -c 'show link stats'
exe cprod -A fpc0 -c 'show ppm adjacencies'
exe cprod -A fpc0 -c 'show threads cpu'
exe cprod -A fpc0 -c 'show halp-l2 mac_table'
exe cprod -A fpc0 -c 'show halp-pkt pkt-stats'
exe cprod -A fpc0 -c 'show route bridge'
exe cprod -A fpc0 -c 'show l2 manager bridge-domains detail'
exe cprod -A fpc0 -c 'show l2 manager mac-table'
exe cprod -A fpc0 -c 'show l2 manager statistics ipc'
exe cprod -A fpc0 -c 'show l2 manager statistics ipc-queue'
exe cprod -A fpc0 -c 'show l2 manager statistics pfe'
exe cprod -A fpc0 -c 'show l2 manager statistics hal'
exe cprod -A fpc0 -c 'show l2 manager hw-to-sw-diff'
exe cprod -A fpc0 -c 'show l2 manager sw-to-hw-diff'                       
exe cprod -A fpc0 -c 'show pfe statistics nhdb'
exe cprod -A fpc0 -c 'show pfe_bcm bcmshell "show errors"'
exe cprod -A fpc0 -c 'show pfe_bcm bcmshell "trunk show"'
exe cprod -A fpc0 -c 'show pfe_bcm bcmshell "pw"'
exe cprod -A fpc0 -c 'show pfe_bcm bcmshell "l2 show"'
exe cprod -A fpc0 -c 'show pfe_bcm bcmshell "l3 l3table show"'
exe cprod -A fpc0 -c 'show pfe_bcm bcmshell "ps"'
exe cprod -A fpc0 -c 'show nhdb all'
exe cprod -A fpc0 -c 'show nhdb summary'
exe cprod -A fpc0 -c 'show nhdb l2addr stats'
exe cprod -A fpc0 -c 'show shim bridge interface'
exe cprod -A fpc0 -c 'show ifd brief'
exe cprod -A fpc0 -c 'show sfp list'
exe cprod -A fpc0 -c 'show filter'
exe cprod -A fpc0 -c 'show filter hw all'
exe cprod -A fpc0 -c 'show filter hw stats'
exe cprod -A fpc0 -c 'show filter hw groups'
exe cprod -A fpc0 -c 'show filter hw fp_slice'
exe cprod -A fpc0 -c 'show filter counters'
