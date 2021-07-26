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
                             

## run command 6 times (every 10 secends)   // 60 sec
for i in 1 2 3 4 5 6 
do
exe cli -c 'show pfe statistics traffic | no-more'
exe cli -c 'show pfe statistics traffic protocol bfd | no-more'
sleep 10
done

