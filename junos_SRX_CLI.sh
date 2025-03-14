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

alias cli='exe cli'

cli -c 'show config groups | no-more'
cli -c 'show config chassis cluster | no-more'
cli -c 'show config interfaces | no-more'
cli -c 'show chassis hardware extensive | no-more'
cli -c 'show chassis fpc pic-status | no-more' 
cli -c 'show chassis fpc detail | no-more' 
cli -c 'show chassis cluster status | no-more'
cli -c 'show chassis cluster interfaces | no-more'   
cli -c 'show chassis cluster information | no-more' 
cli -c 'show chassis cluster information detail | no-more'
cli -c 'show chassis forwarding | no-more' 

cli -c 'show security monitoring performance spu | no-more' 
cli -c 'show security monitoring performance session | no-more'
cli -c 'show security flow session summary | no-more' 
cli -c 'show security flow session resource-manager extensive'
cli -c 'show security alg h323 counters | no-more'

cli -c 'show system security-profile cpu logical-system all | no-more'
cli -c 'show system virtual-memory | no-more'
cli -c 'show system processes extensive | no-more' 
cli -c 'show system alarm | no-more'
cli -c 'show system processes memory | no-more'  # large output 


## run command 6 times (every 10 secends) // 60 sec
for i in 1 2 3 4 5 6 
do
cli -c 'show chassis cluster statistics | no-more'
sleep 10
done

