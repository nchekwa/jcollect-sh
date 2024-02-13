#!/bin/s
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

# CONFIG
cli -c 'show configuration | display omit | except SECRET-DATA | no-more'
cli -c 'show configuration | display omit | except SECRET-DATA | display set | no-more'
cli -c 'show configuration | display omit | display inheritance | except SECRET-DATA | no-more'


cli -c 'show system commit | no-more'
i=0
while [ $i -lt 49 ]; do
	next=$(($i + 1))
	cli -c "show system rollback configuration-revision $i | no-more"
	cli -c "show system rollback $i compare $next | no-more"
	i=$(($i + 1))
done



i=0
while [ $i -lt 49 ]; do
	next=$(($i + 1))
	cli -c "show configuration | compare rollback $next"
	i=$(($i + 1))
done
