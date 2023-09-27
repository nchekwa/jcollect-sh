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

cli -c 'show chassis hardware | no-more'
cli -c 'show interfaces extensive | no-more'
cli -c 'show interfaces diagnostics optics | no-more'

for i in `/usr/sbin/cprod -A fpc0 -c "show qsfp list" | grep '[^[:space:]]' | egrep "qsfp-" | awk '{print $1 ":" $2}'`
do
   qsfp_index=${i%:*}
   qsfp_name=${i#*:}
   qsfp_port=$(echo "$qsfp_name" | cut -d'-' -f2-)
   echo  "#=== $qsfp_index - $qsfp_name"
   echo ""
   cprod -A fpc0 -c "show qsfp $qsfp_index info"
   cprod -A fpc0 -c "show qsfp $qsfp_index alarms"
   cprod -A fpc0 -c "show qsfp $qsfp_index diagnostics"

   for j in `/usr/sbin/cprod -A fpc0 -c "show dcb ifd all" | grep '[^[:space:]]' | egrep $qsfp_port  | awk '{sub(/\r$/,"",$5); print $4 ":" $5}'`
   do
      qsfp_bcm_port_num=${j%:*:}
      qsfp_bcm_port_name=${j#*:}

      echo  "#=== show dcb ifd all> $qsfp_name -> $qsfp_bcm_port_name "
      echo ""
      eval $(printf 'cprod -A fpc0 -c "set dcbcm bcmshell \\"phy diag %s dsc\\"" ' "$qsfp_bcm_port_name")
      eval $(printf 'cprod -A fpc0 -c "set dcbcm bcmshell \\"phy diag %s eyescan\\"" ' "$qsfp_bcm_port_name")
      eval $(printf 'cprod -A fpc0 -c "set dcbcm bcmshell \\"port %s\\"" ' "$qsfp_bcm_port_name")

      ## run command 4 times (every 5 secends) // 20 sec
      for k in 1 2 3 4
      do
      eval $(printf 'cprod -A fpc0 -c "set dcbcm bcmshell \\"show c %s ce0\\"" ' "$qsfp_bcm_port_name")
      sleep 5
      done
      
   done
done

cprod -A fpc0 -c "show syslog messages"
