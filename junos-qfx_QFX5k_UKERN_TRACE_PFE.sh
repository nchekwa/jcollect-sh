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

cprod -A fpc0 -c "show ukern_trace handles"
for i in `/usr/sbin/cprod -A fpc0 -c "show ukern_trace handles" | egrep "^[0-9].* " | awk '{print $1 ":" $2}'`
do
   trace_id=${i%:*}
   trace_name=${i#*:}
   echo ">======================================================================"
   echo  "=== $USER@$hostname:~# cprod -A fpc0 -c \"show ukern_trace $trace_id\"     [$trace_name]"
   echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
   echo "======================================================================="
   echo ""
   /usr/sbin/cprod -A fpc0 -c "show ukern_trace $trace_id"
   echo ""
done
