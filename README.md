# About 'jcollect-sh' collection repository

![Juniper](./img/Juniper_Networks_logo.svg.png)

`jcollect-sh` was created for quick, automated data collection from Juniper devices running Junos OS. The solution's concept is **`fire and forget`** - we run a script that automatically collects necessary information and creates a diagnostic data package (one file) ready to be downloaded from the device.

The `jcollect-sh` repository consists of **5 scripts**:

## jcollect-sh-script.sh [main script - run on Junos OS]

`Bash` script is executed `on Juniper device shell`, which creates a diagnostic data package ready to be downloaded from the device. Files `junos_|junos-qfx_|evo_` placed in the folder together with `jcollect-sh-script.sh` are automatically executed and attached to the collection.

* Details: [jcollect-sh-script.md](./docs/jcollect-sh-script.md)
* Script: [jcollect-sh-script.sh](./jcollect-sh-script.sh)

## jcollect-log-unpacking.py [upload on Juniper / run on local PC]

`Python3` script that is executed `on local PC`, allows to `decompress` and `combine` logs into one file.
In the folder together with `jcollect-sh-script.sh` will be included in the log collection inside LOGS TGZ.
* Details: [jcollect-log-unpacking.md](./docs/jcollect-log-unpacking.md)
* Script: [jcollect-log-unpacking.py](./jcollect-log-unpacking.py)

## jcollect-event-script.py [run on Junos OS]

`Python3` script that is executed `on Juniper device`, in the **EVENT** option (`/var/db/scripts/event/`) or on demand **OP** (operation) (`/var/db/scripts/op/`).

* Details: in annotation of `jcollect-event-script.py` script
* Script: [jcollect-event-script.py](./jcollect-event-script.py)

## jcollect-slicer.py [run on local PC]

`Python3` script that is executed `on local PC`, allows to `slice` log files into individual files (1 file = 1 command).

* Details: N/A
* Script: [jcollect-slicer.py](./jcollect-slicer.py)

## jcollect/jcollect.py [run on local PC]

`Python3` script that is executed `on local PC`, based on configuration in YAML file format config, connects via SSH to Juniper device and collects diagnostic data.

* Details: [jcollect.md](./docs/jcollect.md)
* Script: [jcollect.py](./jcollect/jcollect.py)
