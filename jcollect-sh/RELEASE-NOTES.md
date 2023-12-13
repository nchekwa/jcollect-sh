# JCCOLLECT-SH Release Notes

## v0.5
2023-12-13
* *NEW* - add jcollect-event-script.py which can be used for automated trigger jcollect scripts based on OP/EVENT actions

## v0.4
2023-09-28
* *UPDATE* - Change syntax to use an alias with 'exe' prefix - just to be able to use inside script original commands syntax from ^[beggining line]

## v0.3
2021-07-25

* *NEW* - Documentation
* *NEW* - Calculate and print the size of the TGZ file on the end
* *NEW* - Add example of EXTERNAL junos files (CLIs/QFX5100/SRX/EX4300)
* *NEW* - Script jcollect-log-unpacking.py v0.3 (check documentation)
* *UPDATE* - Change the way of presenting the exe function (first command and then time, so search by command will show time)
* *UPDATE* - Fix 'for' loop statement - {1..3} is not working in POSIX sh

## v0.2
2021-07-24

* *NEW* - Add support EXTERNAL sh scripts (by default only 3 tasks: RSI/archive logs/archive jcollect output)
* *NEW* - Collect additional XML logs on start

## v0.1
2021-07-23

* First release
