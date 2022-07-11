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


X=10
while [[ ${X} -ge 1 ]]
do
  exe srx-cprod.sh -s spu -c "show xlr cpu detail all"
  exe srx-cprod.sh -s spu -c "show dpq drop"
  exe srx-cprod.sh -s spu -c "show dpq stats"
  exe srx-cprod.sh -s spu -c "show xlr pkt_mbuf"
  exe srx-cprod.sh -s spu -c "show usp idp debug-counter flow"
  exe srx-cprod.sh -s spu -c "show usp flow counters all"
  exe srx-cprod.sh -s spu -c "test watchdog snapshot"
  exe srx-cprod.sh -s spu -c "show watchdog snapshot"
  X=$((X-1))
  sleep 30
done


