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


exe uptime
exe df -h
exe df -i
exe ifconfig -a
exe ntpq -pn
exe ntpdc -c "sysstat"
exe ntpdc -c "sysinfo"
exe sysctl -a
exe pciconf -l -v
exe top -s 5 -d 5 -b -n all

