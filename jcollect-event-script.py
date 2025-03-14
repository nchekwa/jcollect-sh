#!/usr/bin/python
#
# FILE-NAME: jcollect-event-script.py
###############################################################################
#
# Mode: EVENT (react on log events)
# !!! The script needs to be located in /var/db/scripts/event/
#
# Run script based on an event (ex. ddos_protocol_violation_set)
#    QFX# set event-options policy ddos-event events ddos_protocol_violation_set
#    QFX# set event-options policy ddos-event then event-script jcollect-event-script.py output-filename event-script.log
#    QFX# set event-options policy ddos-event then event-script jcollect-event-script.py destination LOCAL_VAR_LOG
#    QFX# set event-options policy ddos-event then event-script jcollect-event-script.py output-format text
#    QFX# set event-options destinations LOCAL_VAR_LOG archive-sites /var/log
#
# !!! By default, python scripts run using user nobody.
# 	 QFX# set event-options event-script file jcollect-event-script.py python-script-user <user-name>
#
# Simulate event:
# bash:~ qfx#     logger -e DDOS_PROTOCOL_VIOLATION_SET -a attribute=value -d process -l logical-system-name -p external.notice "message"
# bash:~ evo#     eventd_logger -e DDOS_PROTOCOL_VIOLATION_SET -a attribute=value -d process -l logical-system-name -p external.notice "message"
#
###############################################################################
#
# Mode: OP (operation)
# !!! The script needs to be located in /var/db/scripts/op/
#
# Script needs to be configured in the configuration OP section:
#    QFX# set system scripts op file jcollect-event-script.py
#    QFX# set system scripts language python3
#
# Run script manually:
#    QFX> op jcollect-event-script.py
#
# ###############################################################################
# WARNING: Junos will not work with linked file by "ln -l" / error occur 'Authentication error'
# Copy files:
# event -> op:    cp /var/db/scripts/event/jcollect-event-script.py /var/db/scripts/op/jcollect-event-script.py
# op -> event:    cp /var/db/scripts/op/jcollect-event-script.py /var/db/scripts/event/jcollect-event-script.py
#
#

import os
from datetime import datetime

# Path to the directory containing the scripts
jcollect_scripts_directory = "/var/tmp/"
output_directory = "/var/tmp/"

# Dictionary of prefixes and their meanings
prefix_dict = {
    "junos_CLI_": "Junos CLI scripts",
    "junos-qfx_QFX_": "Junos QFX-specific scripts",
    # Add more prefixes and their meanings as needed
}

# Print starting timestamp
start_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
print(f"> Script execution started at: {start_time}")
print("> ")

# List all files in the directory
files = os.listdir(jcollect_scripts_directory)

# Filter shell scripts starting with specified prefixes
shell_scripts = [file for file in files if any(file.startswith(prefix) for prefix in prefix_dict.keys()) and file.endswith(".sh")]


# Check if there are scripts to execute
if shell_scripts:
    # Create folder with current timestamp
    logs_folder_name = datetime.now().strftime("%Y%m%d-%H%M%S")
    output_folder = os.path.join(output_directory, logs_folder_name)
    os.makedirs(output_folder)
    print(f"> file list {output_folder}")
    print("> ")

    # Execute each shell script and move output to the created folder
    for script in shell_scripts:
        output_file = script.replace(".sh", ".log")
        prefix = next(prefix for prefix in prefix_dict.keys() if script.startswith(prefix))
        script_description = prefix_dict[prefix]

        print(f"Run {script_description}: {jcollect_scripts_directory}{script} > {output_folder}/{output_file}")
        command = f"sh {jcollect_scripts_directory}{script} > {output_folder}/{output_file} 2>&1"
        os.system(command)
        print(f"> file show {output_folder}/{output_file}")
else:
    print("No scripts to execute.")


# Print ending timestamp
end_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
print("> ")
print(f"> Script execution ended at: {end_time}")
print("All Done")
