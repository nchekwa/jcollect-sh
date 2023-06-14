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

exe cli -c 'show chassis hardware | no-more'
exe cli -c 'show interfaces extensive | no-more'
exe cli -c 'show interfaces diagnostics optics | no-more'

for i in `cprod -A fpc0 -c "show qsfp list" | grep '[^[:space:]]' | egrep "qsfp-" | awk '{print $1 ":" $2}'`
do
   qsfp_index=${i%:*}
   qsfp_name=${i#*:}
   qsfp_port=$(echo "$qsfp_name" | cut -d'-' -f2-)
   echo  "=== $qsfp_index - $qsfp_name"
   echo ""
   exe cprod -A fpc0 -c "show qsfp $qsfp_index info"
   exe cprod -A fpc0 -c "show qsfp $qsfp_index alarms"
   exe cprod -A fpc0 -c "show qsfp $qsfp_index diagnostics"

   for j in `cprod -A fpc0 -c "show dcb ifd all" | grep '[^[:space:]]' | egrep $qsfp_port  | awk '{sub(/\r$/,"",$4); print $4 ":" $5}'`
   do
      qsfp_bcm_port_num=${j%:*:}
      qsfp_bcm_port_name=${j#*:}

      echo  "=== show dcb ifd all> $qsfp_name -> $qsfp_bcm_port_name "
      echo ""
      exe eval $(printf 'cprod -A fpc0 -c "set dcbcm bcmshell \\"phy diag %s dsc\\"" ' "$qsfp_bcm_port_name")
      exe eval $(printf 'cprod -A fpc0 -c "set dcbcm bcmshell \\"phy diag %s eyescan\\"" ' "$qsfp_bcm_port_name")
      exe eval $(printf 'cprod -A fpc0 -c "set dcbcm bcmshell \\"port %s\\"" ' "$qsfp_bcm_port_name")
      exe eval $(printf 'cprod -A fpc0 -c "set dcbcm bcmshell \\"show c %s ce0\\"" ' "$qsfp_bcm_port_name")
   done
done

exe cprod -A fpc0 -c "show syslog messages"
