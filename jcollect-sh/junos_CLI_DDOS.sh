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

# DDOS-PROTECTION
cli -c 'show ddos-protection version | no-more'
cli -c 'show ddos-protection statistics | no-more'
cli -c 'show ddos-protection protocols | no-more'
cli -c 'show ddos-protection protocols statistics brief | no-more'
cli -c 'show ddos-protection protocols statistics terse | no-more'
cli -c 'show ddos-protection protocols statistics | no-more'
cli -c 'show ddos-protection protocols violations | no-more'
cli -c 'show ddos-protection protocols vxlan violations | no-more'
cli -c 'show ddos-protection protocols arp violations | no-more'

cprod -A fpc0 -c 'show dcbcm ifd all'
cprod -A fpc0 -c "show halp-pkt asic-queues"

## run command 6 times (every 10 secends)   // 60 sec
for i in 1 2 3 4 5 6 
do
cprod -A fpc0 -c 'set dcbcm bcmshell "show c"'
cprod -A fpc0 -c "show halp-pkt pkt-stats"
sleep 10
done
