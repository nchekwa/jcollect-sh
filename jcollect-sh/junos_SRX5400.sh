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


n=1
while [ $n -lt 10 ]
do
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
  sleep 30
done
