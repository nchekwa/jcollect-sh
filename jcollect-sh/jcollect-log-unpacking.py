#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# Name: jcollect-log-unpacking.py
# Version: v0.3 [2021-07-24] - First release
# Version: v0.4 [2021-08-26] - Resolve problem with files like ie. op-script.log.0.gz
#                            - Resolve problem with UnicodeDecodeError: 'utf-8' codec can't decode byte
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

import os
from pprint import pprint
import gzip

# Gun ZIP
def gunzip(source_filepath, dest_filepath, block_size=65536):
    print("|-- GUNZIP "+source_filepath+" -> "+ dest_filepath)
    with gzip.open(source_filepath, 'rb') as s_file, \
            open(dest_filepath, 'wb') as d_file:
        while True:
            block = s_file.read(block_size)
            if not block:
                break
            else:
                d_file.write(block)

# Human readable file size
def human_readable_size(size, decimal_places=2):
    for unit in ['B','KiB','MiB','GiB','TiB']:
        if size < 1024.0:
            break
        size /= 1024.0
    return f"{size:.{decimal_places}f}{unit}"

# Main
def main():
    # Create List of files with GZ extension
    files_compressed = list()
    path = os.listdir(r".")
    for filename in path:
        if filename.endswith(".gz"):
            filenamepart = filename.split(".")
            files_compressed.append(filenamepart[0])
    gzFfiles = list(dict.fromkeys(files_compressed))


    # Decompress and merge files
    file_for_decompress = list()
    for filename in gzFfiles:
        print(">-- log: "+filename+"* ---")
        files_to_merge = [filename, filename+".log"]
        for fn in path:
            if fn.endswith(".gz") and  fn.startswith(filename):
                file = fn.rsplit('.', 1)
                gz_file_name    = file[0]
                file = gz_file_name.rsplit('.', 1)
                gz_file_name    = file[0]
                gz_file_id      = file[1]
                
                gz_file         = fn
                txt_file        = gz_file_name+"."+gz_file_id
                
                file_for_decompress.append(gz_file)
                gunzip("./"+gz_file ,  "./"+txt_file)
                files_to_merge.append(txt_file)
                os.remove("./"+gz_file)
                print("|-- REMOVE: "+gz_file)
        
        # Skip merge wtmp file as it is not text file
        if files_to_merge[0] == "wtmp":
            print("\n")
            continue
        
        # Marge TXT files into one
        with open(files_to_merge[0]+"_merge", 'w') as outfile:
            print("|-- MERGE TO: "+files_to_merge[0]+"_merge")
            files_to_merge.sort()
            for fname in list(reversed(files_to_merge)) :
                if os.path.isfile(fname):
                    if os.path.getsize(fname) != 0:
                        fsize = os.path.getsize(fname)
                        print(" |-- FILE: "+ fname+" SIZE: "+human_readable_size(fsize)+"  ["+str(fsize)+"]" )
                        with open("./"+fname, encoding='utf-8', errors='ignore') as infile:
                            for line in infile:
                                outfile.write(line)
        print("----------------------------------------------------------------------------------------------------")
        print("\n")
                
### RUN Main ###
if __name__ == "__main__":
    main()