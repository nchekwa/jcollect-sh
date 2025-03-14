# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## [0.5.1] - 2025-03-14

### Changed
- Update documentation and repository files schema location
- Release Notes -> Keep a Changelog

## [0.5.0] - 2023-12-13

### Added
- jcollect-event-script.py which can be used for automated trigger jcollect scripts based on OP/EVENT actions


## [0.4.0] - 2023-09-28

### Changed
- Change syntax to use alias with 'exe' prefix - just to be able use inside script original commands syntax from ^[beggining line]

## [0.3.0] - 2021-07-25

### Added
- Documentation
- Calculate and print size of the TGZ file on the end
- Add exemple of EXTERNAL junos files (CLIs/QFX5100/SRX/EX4300)
- Script jcollect-log-unpacking.py v0.3 (check documentation)

### Changed
- Change the way of presenting exe function (first command and then time, so search by command will shows time)
- Fix 'for' loop statment - {1..3} is not working in POSIX sh

## [0.2.0] - 2021-07-24

### Added
- Add support EXTERNAL sh scripts (by default only 3 task: RSI/archive logs/archve jcollect output)
- Collect additional XML logs on start

## [0.1.0] - 2021-07-23

### Added
- First release
