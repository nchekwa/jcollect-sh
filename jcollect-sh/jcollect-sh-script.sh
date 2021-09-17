#!/bin/sh
#
# Name: jcollect-sh-script.sh
# Version: 0.2 [2021-07-24]
#
# Copyright 2021 Artur Zdolinski
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

file_path="/var/tmp/jcollect/"

date_time=$(date '+%Y-%m-%d %H:%M:%S')
date_time_fname=$(date '+%Y%m%dT%H%M%S_%s')
hostname=$(hostname -s)
PIDFILE=/var/tmp/jcollect-sh.pid
TASKTIMEOUT=1800

print_status () {
    echo ""
    epoch_start_task=$(date '+%s')
    echo ">-- START TASK: $action"
}

run_background () {
    printf "%s PID: %-5s | %s | %s \n" "---" $PID "$(date '+%Y-%m-%d %H:%M:%S %Z [%z]')" "$epoch_start_task"
    local sec=0
    local line=0
    local mod=0
    echo -n "[    0] "
    while ps -p $PID > /dev/null
    do 
        mod=$(( $sec % 60 ))
        if ([ $mod -eq 0 ] && [ $sec -ne 0 ])
            then
            line=$((line + 60))
            fi
        if ([ $mod -eq 0 ] && [ $line -ne 0 ])
            then
            printf "\n[%5s] " $line
            fi
        if ([ $sec -gt $TASKTIMEOUT ])
            then
            echo "--- ERROR: Action taking to long. This is not normal. please check the TASK manually. EXIT"
            exit 1
            fi
        echo -n "." 
        sec=$((sec + 1))
        sleep 1
    done; 

    epoch_end_task=$(date '+%s')
    local epoch_delta=$(( $epoch_end_task - $epoch_start_task ))
    printf "\n[%5s] DONE\n" $epoch_delta
    echo "--- END TASK   | $(date '+%Y-%m-%d %H:%M:%S %Z [%z]') | $epoch_end_task"
}

task_tar_all () {
    echo ""
    echo ">-- START TASK: TAR All Files"
    # Rename folder before compress [format: date + hour + hostname + jcollect]
    new_jcollect_folder_name=$(date '+%Y-%m-%d_T%H%M')\_$hostname\_jcollect
    mv $file_path $file_path_minus1/$new_jcollect_folder_name
    # Compress
    cd $file_path_minus1; tar -zcvf /var/tmp/$new_jcollect_folder_name.tgz $new_jcollect_folder_name/*
    # Make link to latest file
    rm -f $file_path_minus1/jcollect_latest.tgz
    ln -s $file_path_minus1/$new_jcollect_folder_name.tgz $file_path_minus1/jcollect_latest.tgz
    # Rollback folder name
    mv $file_path_minus1/$new_jcollect_folder_name $file_path
    echo "--- File: $file_path_minus1/$new_jcollect_folder_name.tgz"
    echo "    -or-: $file_path_minus1/jcollect_latest.tgz"

    FILESIZE_B=$(ls -l $file_path_minus1/$new_jcollect_folder_name.tgz | awk '{print $5}')
    FILEFILE=$(echo "${FILESIZE_B}" | awk '{ split( "B KB MB GB TB PB" , v ); s=1; while( $1>1024 ){ $1/=1024; s++ } printf "%.2f %s", $1, v[s] }')
    echo "--- Size: $FILEFILE"
}

system_info_dump () {
    cli -c "show system information | display xml | no-more" > $file_path/xml/show_system_information.xml
    cli -c "show system uptime | display xml | no-more" > $file_path/xml/show_system_uptime.xml
    cli -c "show interfaces extensive | display xml | no-more" > $file_path/xml/show_interfaces_extensive.xml
    cli -c "show lldp neighbors | display xml | no-more" > $file_path/xml/show_lldp_neighbors.xml

    serialnumber=$(cat $file_path/xml/show_system_information.xml | grep serial-number | awk -F">" '{print $2}' | awk -F"<" '{print $1}')
    hardwaremodel=$(cat $file_path/xml/show_system_information.xml | grep hardware-model | awk -F">" '{print $2}' | awk -F"<" '{print $1}')
    osversion=$(cat $file_path/xml/show_system_information.xml | grep os-version | awk -F">" '{print $2}' | awk -F"<" '{print $1}')
    osname=$(cat $file_path/xml/show_system_information.xml | grep os-name | awk -F">" '{print $2}' | awk -F"<" '{print $1}')
    uptime=$(cat $file_path/xml/show_system_uptime.xml | grep up-time | awk -F">" '{print $2}' | awk -F"<" '{print $1}')
    timesource=$(cat $file_path/xml/show_system_uptime.xml | grep time-source | awk -F">" '{print $2}' | awk -F"<" '{print $1}' | sed -e 's/^[[:space:]]*//')
}

check_pid () {
    if [ -f $PIDFILE ]
    then
    PID=$(cat $PIDFILE)
    ps -p $PID > /dev/null 2>&1
    if [ $? -eq 0 ]
    then
        echo "Process already running | $PIDFILE -> PID: $PID"
        exit 1
    else
        ## Process not found assume not running
        echo $$ > $PIDFILE
        if [ $? -ne 0 ]
        then
        echo "Could not create PID file $PIDFILE"
        exit 1
        fi
    fi
    else
    echo $$ > $PIDFILE
    if [ $? -ne 0 ]
    then
        echo "Could not create PID file $PIDFILE"
        exit 1
    fi
    fi
}
# =================================================================================================
# MAIN:
# =================================================================================================
check_pid
file_path=${file_path%/}
file_path_minus1=${file_path%/*}

rm -r -f $file_path
mkdir $file_path
mkdir $file_path/xml

echo ">-- Collect basic data... "
system_info_dump
echo "---"
echo "--- Current time:        $date_time | $(date '+%s')"
echo "--- Local Time Zone:     $(date '+%Z [%z]')"
echo "--- Time Source:         $timesource"
echo "--- Hostname:            $hostname"
echo "--- Uptime:              $uptime"
echo "--- OS Name/Version:     $osname / $osversion"
echo "--- Hardware Model:      $hardwaremodel"
echo "--- Serial Number:       $serialnumber" 
echo "--- User:                $USER"
echo "--- Temp Folder Path:    $file_path"
echo ""

# =================================================================================================
# TASKS:
# =================================================================================================
# TASK - Check if in our folder there are some J_EXTERNAL SH scripts to run
j_files=`ls junos_*.sh junos-qfx_*.sh evo*.sh 2>/dev/null`
for j_ext in $j_files
do
    # Prevent loop - we dont whant to run in loop with this script
    if [ $j_ext != ${0##*/} ]
    then
        j_file_noExt=$(echo "$j_ext" | sed -e "s/\.[^.]*$//")
        a=$(echo "$j_file_noExt" | sed -e "s/^junos_//;s/^junos-qfx_//;s/^evo_//" -e "s/_/ /g")
        action="${a} [EXTERNAL]"
        cp $j_ext $file_path/$j_ext
        print_status
        sh $j_ext >$file_path/$j_file_noExt.log 2>&1 &
        PID=$(echo $!)
        run_background
    fi
done

# TASK RSI
action="Generate RSI"
print_status
cli -c "request support information | save $file_path/RSI_$hostname_$date_time_fname.txt" > $file_path/RSI_command_output_log.log 2>&1 &
PID=$(echo $!)
run_background

# Include JCollect Log Unpacking script
if [ -e jcollect-log-unpacking.py ]
  then
  mv jcollect-log-unpacking.py /var/log/
fi
# TASK TAR Logs
action="TAR logs from /var/log/"
print_status
cd /var/; tar -zcvf $file_path/LOGS_$hostname_$date_time_fname.tgz log/* > $file_path/LOGS_command_output_log.log 2>&1 &
PID=$(echo $!)
run_background

# TASK TAR ALL JCollect files
task_tar_all
# =================================================================================================
# =================================================================================================
# =================================================================================================
rm -f /var/log/jcollect-log-unpacking.py 
echo "--- ALL DONE!"
rm -f $PIDFILE