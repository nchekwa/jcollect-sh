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

cprod -A fpc0 -c "show ukern_trace handles"
for i in `/usr/sbin/cprod  -A fpc0 -c "show ukern_trace handles" | egrep "^[0-9].* " | awk '{print $1 ":" $2}'`
do
   trace_id=${i%:*}
   trace_name=${i#*:}
   echo ">======================================================================"
   echo "=== $USER@$hostname:~# cprod -A fpc0 -c \"show ukern_trace $trace_id\"     [$trace_name]" 
   echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
   echo "======================================================================="
   echo ""
   /usr/sbin/cprod  -A fpc0 -c "show ukern_trace $trace_id"
   echo ""
done


cprod -A fpc0 -c 'show ppm statistics protocol lacp'
cprod -A fpc0 -c 'show link stats'
cprod -A fpc0 -c 'show ppm adjacencies'
cprod -A fpc0 -c 'show threads cpu'
cprod -A fpc0 -c 'show halp-l2 mac_table'
cprod -A fpc0 -c 'show halp-pkt pkt-stats'
cprod -A fpc0 -c 'show route bridge'
cprod -A fpc0 -c 'show l2 manager bridge-domains detail'
cprod -A fpc0 -c 'show l2 manager mac-table'
cprod -A fpc0 -c 'show l2 manager statistics ipc'
cprod -A fpc0 -c 'show l2 manager statistics ipc-queue'
cprod -A fpc0 -c 'show l2 manager statistics pfe'
cprod -A fpc0 -c 'show l2 manager statistics hal'
cprod -A fpc0 -c 'show l2 manager hw-to-sw-diff'
cprod -A fpc0 -c 'show l2 manager sw-to-hw-diff'                       
cprod -A fpc0 -c 'show pfe statistics nhdb'
cprod -A fpc0 -c 'show pfe_bcm bcmshell "show errors"'
cprod -A fpc0 -c 'show pfe_bcm bcmshell "trunk show"'
cprod -A fpc0 -c 'show pfe_bcm bcmshell "pw"'
cprod -A fpc0 -c 'show pfe_bcm bcmshell "l2 show"'
cprod -A fpc0 -c 'show pfe_bcm bcmshell "l3 l3table show"'
cprod -A fpc0 -c 'show pfe_bcm bcmshell "ps"'
cprod -A fpc0 -c 'show nhdb all'
cprod -A fpc0 -c 'show nhdb summary'
cprod -A fpc0 -c 'show nhdb l2addr stats'
cprod -A fpc0 -c 'show shim bridge interface'
cprod -A fpc0 -c 'show ifd brief'
cprod -A fpc0 -c 'show sfp list'
cprod -A fpc0 -c 'show filter'
cprod -A fpc0 -c 'show filter hw all'
cprod -A fpc0 -c 'show filter hw stats'
cprod -A fpc0 -c 'show filter hw groups'
cprod -A fpc0 -c 'show filter hw fp_slice'
cprod -A fpc0 -c 'show filter counters'
