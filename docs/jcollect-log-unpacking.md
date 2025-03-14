# Log Unpacking Tool for Juniper Devices

## What This Tool Does

The `jcollect-log-unpacking.py` script is a helper tool that simplifies working with Juniper device logs. When you run this tool, it will:

1. Find all compressed log files (*.gz) in your current directory
2. Decompress them automatically
3. Merge related log files (e.g., messages.0, messages.1, messages.2) into a single file
4. Create a combined file (e.g., messages_merge) that contains all logs in the correct chronological order

This makes it much easier to analyze logs, especially when troubleshooting issues that might span across multiple log files.

## When To Use This Tool

Use this tool when:
- You need to analyze multiple log files from a Juniper device
- You want to see a complete history of logs in chronological order
- You're working with logs collected by the jcollect-sh-script.sh tool

## How To Use This Tool

### Setup (Happens Automatically)

If you run the `jcollect-sh-script.sh` tool - you can put  the `jcollect-log-unpacking.py` file in the same directory, the script will be automatically included in the archive. This happens without you needing to do anything. Later, on your PC you will be able inside `logs` folder just to run this script without needs to copy file to your folder.

### Running The Tool

After you extract your log files from the `jcollect archive`, follow these steps:

1. Navigate to the log directory
2. Run the Python script (`on local PC`) example for Linux Users:

```bash
# First, go to the log directory in your extracted jcollect archive
bash# cd /home/user/YYYY-MM-DD_THHMM_hostname_jcollect/log

# Verify the script is there
bash#ls jcollect*
> jcollect-log-unpacking.py

# Run the script
bash# python3 jcollect-log-unpacking.py
```

### What Happens When You Run The Script

The script will:
1. Find all .gz files in the current directory
2. Group them by file type (e.g., messages, interactive-commands, etc.)
3. Decompress each file
4. Create a merged file for each group in correct order

## Example Output

When you run the script, you'll see output similar to this:

```bash
>-- log: interactive-commands* ---
|-- GUNZIP ./interactive-commands.4.gz -> ./interactive-commands.4
|-- REMOVE: interactive-commands.4.gz
|-- GUNZIP ./interactive-commands.0.gz -> ./interactive-commands.0
|-- REMOVE: interactive-commands.0.gz
|-- GUNZIP ./interactive-commands.8.gz -> ./interactive-commands.8
|-- REMOVE: interactive-commands.8.gz
|-- GUNZIP ./interactive-commands.6.gz -> ./interactive-commands.6
|-- REMOVE: interactive-commands.6.gz
|-- GUNZIP ./interactive-commands.3.gz -> ./interactive-commands.3
|-- REMOVE: interactive-commands.3.gz
|-- GUNZIP ./interactive-commands.9.gz -> ./interactive-commands.9
|-- REMOVE: interactive-commands.9.gz
|-- GUNZIP ./interactive-commands.1.gz -> ./interactive-commands.1
|-- REMOVE: interactive-commands.1.gz
|-- GUNZIP ./interactive-commands.2.gz -> ./interactive-commands.2
|-- REMOVE: interactive-commands.2.gz
|-- GUNZIP ./interactive-commands.5.gz -> ./interactive-commands.5
|-- REMOVE: interactive-commands.5.gz
|-- GUNZIP ./interactive-commands.7.gz -> ./interactive-commands.7
|-- REMOVE: interactive-commands.7.gz
|-- MERGE TO: interactive-commands_merge
 |-- FILE: interactive-commands.9 SIZE: 483.579KiB  [495185]
 |-- FILE: interactive-commands.8 SIZE: 482.853KiB  [494441]
 |-- FILE: interactive-commands.7 SIZE: 486.400KiB  [498074]
 |-- FILE: interactive-commands.6 SIZE: 482.860KiB  [494449]
 |-- FILE: interactive-commands.5 SIZE: 540.341KiB  [553309]
 |-- FILE: interactive-commands.4 SIZE: 488.217KiB  [499934]
 |-- FILE: interactive-commands.3 SIZE: 495.734KiB  [507632]
 |-- FILE: interactive-commands.2 SIZE: 501.418KiB  [513452]
 |-- FILE: interactive-commands.1 SIZE: 510.241KiB  [522487]
 |-- FILE: interactive-commands.0 SIZE: 494.884KiB  [506761]
 |-- FILE: interactive-commands SIZE: 367.169KiB  [375981]
----------------------------------------------------------------------------------------------------


>-- log: mib2d* ---
|-- GUNZIP ./mib2d.0.gz -> ./mib2d.0
|-- REMOVE: mib2d.0.gz
|-- GUNZIP ./mib2d.4.gz -> ./mib2d.4
|-- REMOVE: mib2d.4.gz
|-- GUNZIP ./mib2d.3.gz -> ./mib2d.3
|-- REMOVE: mib2d.3.gz
|-- GUNZIP ./mib2d.1.gz -> ./mib2d.1
|-- REMOVE: mib2d.1.gz
|-- GUNZIP ./mib2d.2.gz -> ./mib2d.2
|-- REMOVE: mib2d.2.gz
|-- MERGE TO: mib2d_merge
 |-- FILE: mib2d.4 SIZE: 990.519KiB  [1014291]
 |-- FILE: mib2d.3 SIZE: 990.516KiB  [1014288]
 |-- FILE: mib2d.2 SIZE: 990.540KiB  [1014313]
 |-- FILE: mib2d.1 SIZE: 990.476KiB  [1014247]
 |-- FILE: mib2d.0 SIZE: 990.474KiB  [1014245]
 |-- FILE: mib2d SIZE: 103.595KiB  [106081]
----------------------------------------------------------------------------------------------------


>-- log: messages* ---
|-- GUNZIP ./messages.3.gz -> ./messages.3
|-- REMOVE: messages.3.gz
|-- GUNZIP ./messages.4.gz -> ./messages.4
|-- REMOVE: messages.4.gz
|-- GUNZIP ./messages.8.gz -> ./messages.8
|-- REMOVE: messages.8.gz
|-- GUNZIP ./messages.0.gz -> ./messages.0
|-- REMOVE: messages.0.gz
|-- GUNZIP ./messages.2.gz -> ./messages.2
|-- REMOVE: messages.2.gz
|-- GUNZIP ./messages.7.gz -> ./messages.7
|-- REMOVE: messages.7.gz
|-- GUNZIP ./messages.5.gz -> ./messages.5
|-- REMOVE: messages.5.gz
|-- GUNZIP ./messages.9.gz -> ./messages.9
|-- REMOVE: messages.9.gz
|-- GUNZIP ./messages.1.gz -> ./messages.1
|-- REMOVE: messages.1.gz
|-- GUNZIP ./messages.6.gz -> ./messages.6
|-- REMOVE: messages.6.gz
|-- MERGE TO: messages_merge
 |-- FILE: messages.9 SIZE: 249.396KiB  [255381]
 |-- FILE: messages.8 SIZE: 246.397KiB  [252311]
 |-- FILE: messages.7 SIZE: 255.753KiB  [261891]
 |-- FILE: messages.6 SIZE: 250.625KiB  [256640]
 |-- FILE: messages.5 SIZE: 252.042KiB  [258091]
 |-- FILE: messages.4 SIZE: 245.555KiB  [251448]
 |-- FILE: messages.3 SIZE: 249.303KiB  [255286]
 |-- FILE: messages.2 SIZE: 247.055KiB  [252984]
 |-- FILE: messages.1 SIZE: 240.481KiB  [246253]
 |-- FILE: messages.0 SIZE: 380.741KiB  [389879]
 |-- FILE: messages SIZE: 94.734KiB  [97008]
----------------------------------------------------------------------------------------------------


>-- log: wtmp* ---
|-- GUNZIP ./wtmp.0.gz -> ./wtmp.0
|-- REMOVE: wtmp.0.gz


>-- log: chassisd* ---
|-- GUNZIP ./chassisd.0.gz -> ./chassisd.0
|-- REMOVE: chassisd.0.gz
|-- MERGE TO: chassisd_merge
 |-- FILE: chassisd.0 SIZE: 2.894MiB  [3034265]
 |-- FILE: chassisd SIZE: 66.239KiB  [67829]
----------------------------------------------------------------------------------------------------


>-- log: dcd* ---
|-- GUNZIP ./dcd.0.gz -> ./dcd.0
|-- REMOVE: dcd.0.gz
|-- MERGE TO: dcd_merge
 |-- FILE: dcd.0 SIZE: 976.478KiB  [999913]
 |-- FILE: dcd SIZE: 18.967KiB  [19422]
----------------------------------------------------------------------------------------------------
```

## After Running The Script

Once the script finishes, you'll have:

1. All your log files decompressed (no more .gz files)
2. New "*_merge" files that combine all related logs in chronological order

For example, if you had:
- messages
- messages.0.gz
- messages.1.gz
- messages.2.gz

You'll now have:
- messages
- messages.0
- messages.1
- messages.2
- messages_merge (contains all messages from the above files in order)

## Tips For Working With Log Files

- The "*_merge" files contain all the logs in reverse chronological order (newest entries first)
- For large log sets, this tool saves you considerable time that would otherwise be spent manually decompressing and examining multiple files
- The tool automatically handles non-UTF-8 files by skipping them
- Empty files are also skipped automatically

## Common Log Files and What They Contain

Here are some of the most important log files you'll find:

- **messages**: System messages including errors, warnings, and informational messages
- **interactive-commands**: Record of commands entered at the CLI
- **chassisd**: Chassis-related events and alarms
- **dcd**: Interface and routing configuration events
- **mib2d**: SNMP-related events

Examining these logs can help you troubleshoot issues with your Juniper device.