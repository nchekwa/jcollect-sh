#!/bin/sh
# bash# sh junos_SRX5400.sh > /var/tmp/`date +"%Y%m%d_%H%M%S"`-"$HOST"-cprod.txt
hostname=$(hostname -s)
exe() {
echo ">======================================================================"
echo "=== $USER@$hostname:~# $@"
echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
echo "======================================================================="
echo ""
"$@" 
echo ""; }


n=1
while [ $n -le 10 ]
do
  
  while true; do
    # Run script exactly in 30sec intervals - at: hh:mm:00 -or- hh:mm:30
    d=$(date +%S)
    if [ $d -eq 0 -o $d -eq 30 ]; then
      echo -n "x== n=$n "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
      break 1
    else
      #echo "x== waiting - sec=$d"
      sleep 0.2
    fi
  done
  
  exe srx-cprod.sh -s spu -c "show xlr cpu detail all"
  exe srx-cprod.sh -s spu -c "show dpq drop"
  exe srx-cprod.sh -s spu -c "show dpq stats"
  exe srx-cprod.sh -s spu -c "show xlr pkt_mbuf"
  exe srx-cprod.sh -s spu -c "show usp idp debug-counter flow"
  exe srx-cprod.sh -s spu -c "show usp flow counters all"
  exe srx-cprod.sh -s spu -c "test watchdog snapshot"
  exe srx-cprod.sh -s spu -c "show watchdog snapshot"
  exe srx-cprod.sh -s spu -c "show usp flow counters resource-mgr-cpu"
  exe srx-cprod.sh -s spu -c "show usp resource-manager cpu"
  n=$(( n+1 ))
done
