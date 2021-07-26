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



exe cli -c 'show config groups | no-more'
exe cli -c 'show config chassis cluster | no-more'
exe cli -c 'show config interfaces | no-more'

exe cli -c 'show chassis hardware | no-more'
exe cli -c 'show chassis fpc pic-status | no-more' 
exe cli -c 'show chassis cluster status | no-more'
exe cli -c 'show chassis cluster interfaces | no-more'   
exe cli -c 'show chassis cluster information | no-more' 
exe cli -c 'show chassis cluster information detail | no-more'
exe cli -c 'show chassis routing-engine | no-more' 
exe cli -c 'show chassis forwarding | no-more' 

exe cli -c 'show security monitoring performance spu | no-more' 
exe cli -c 'show security monitoring performance session | no-more'
exe cli -c 'show security flow session summary | no-more' 
exe cli -c 'show security flow session resource-manager extensive'
exe cli -c 'show security alg h323 counters | no-more'

exe cli -c 'show system virtual-memory | no-more'
exe cli -c 'show system processes extensive | no-more' 
exe cli -c 'show system alarm | no-more'
exe cli -c 'show system processes memory | no-more'  # large output 

## run command 6 times (every 10 secends) // 60 sec
for i in 1 2 3 4 5 6 
do
exe cli -c 'show chassis cluster statistics | no-more'
sleep 10
done

