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

cprod -A fpc0 -c "show bridge-domain"
for i in `/usr/sbin/cprod  -A fpc0 -c "show bridge-domain" |  grep '[^[:space:]]' | egrep -v "^Bridging Domain" | awk '{print $1 ":" $2}'`
do
   bd_name=${i%:*}
   bd_index=${i#*:}
   echo ">======================================================================"
   echo  "=== $USER@$hostname:~# cprod -A fpc0 -c \"show bridge-domain entry 0x$bd_index ifbd all\"     [$bd_name]"
   echo -n "=== "; date '+%Y-%m-%d %H:%M:%S %Z [%z] | %s'
   echo "======================================================================="
   echo ""
   cprod -A fpc0 -c "show bridge-domain entry 0x$bd_index ifbd all"
   echo ""
done

cprod -A fpc0 -c "show bridge-domain irb"