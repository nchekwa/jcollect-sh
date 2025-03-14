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

cprod -A fpc0 -c "show l2 manager mac-table"
cprod -A fpc0 -c "show l2 manager ctxt-history"
#cprod -A fpc0 -c "show l2 manager ctxt-history mac-address 00:00:5e:00:01:7f"

cprod -A fpc0 -c 'show ifl'
cprod -A fpc0 -c 'show ifl brief'
cprod -A fpc0 -c 'show ifd'
cprod -A fpc0 -c 'show ifd brief'

cprod -A fpc0 -c 'show bridge-domain'
cprod -A fpc0 -c 'show l2 manager bridge-domains'
cprod -A fpc0 -c 'show route bridge'

cprod -A fpc0 -c 'show dcbcm ifd all'

cprod -A fpc0 -c 'show storm_cntl profile'
cprod -A fpc0 -c 'show storm_cntl profile bindings'

cprod -A fpc0 -c 'show halp-pkt pkt-stats'
cprod -A fpc0 -c 'show halp-pkt asic-queues'
cprod -A fpc0 -c 'show halp-pkt hostpath-cfgs'

cprod -A fpc0 -c 'show ttp statistics'

cprod -A fpc0 -c 'show shim mclag-info'
cprod -A fpc0 -c 'show shim trunk statistics'
cprod -A fpc0 -c 'show shim bridge interface'

cprod -A fpc0 -c 'show route ip'
cprod -A fpc0 -c 'show heap'

cprod -A fpc0 -c 'show nhdb'
cprod -A fpc0 -c 'show nhdb management all'

cprod -A fpc0 -c 'show pfe manager stat'

cprod -A fpc0 -c 'show syslog messages'

## run command 4 times (every 10 secends) // 40 sec
for i in 1 2 3 4
do
cprod -A fpc0 -c 'show halp-pkt pkt-stats'
cprod -A fpc0 -c 'show ttp stat'
sleep 10
done
