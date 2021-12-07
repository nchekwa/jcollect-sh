#!/bin/bash

FILES=("jcollect-sh-script.sh" "junos_CLI_BGP.sh")
HOSTS=("10.240.40.30" "10.240.30.31")
USERNAME=root
PASSWORD=root123
PATH=/var/root

# Remove old files if needed via SSH:
# *** BE CAREFUL !!! ***
# ie.:
# bash# cd /var/root ; rm jcollect-* junos_* junos-*

for host in "${HOSTS[@]}"; do
  for file in "${FILES[@]}"; do
  /usr/bin/curl -v --max-time 3 --insecure -k -T $file scp://$USERNAME:$PASSWORD@$host:22/$PATH/$file
  done
done
exit 0

