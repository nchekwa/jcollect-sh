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

exe vmstat -afimsz
exe sysctl -a
exe rtinfo -rnV
exe ifsmon -dt
exe ifsmon -p
exe ifsmon -kd
exe nhinfo -ad