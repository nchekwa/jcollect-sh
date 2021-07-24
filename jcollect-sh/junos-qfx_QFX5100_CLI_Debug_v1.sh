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
                             

## run command 6 times (every 10 secends)
for i in {1..6}; 
do
exe cli -c 'show pfe statistics traffic | no-more'
exe cli -c 'show pfe statistics traffic protocol bfd | no-more'
sleep 10
done

