
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Version: 0.0.1 - contact: artur@zdolinski.com

v0.0.1 [2021-05-05] - First release
"""

import os
from pprint import pprint
import gzip

# Gun ZIP
def gunzip(source_filepath, dest_filepath, block_size=65536):
    print("|-GUNZIP "+source_filepath+" -> "+ dest_filepath)
    with gzip.open(source_filepath, 'rb') as s_file, \
            open(dest_filepath, 'wb') as d_file:
        while True:
            block = s_file.read(block_size)
            if not block:
                break
            else:
                d_file.write(block)

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
        print("--- "+filename+" ---")
        files_to_merge = [filename]
        for fn in path:
            if fn.endswith(".gz") and  fn.startswith(filename):
                file = fn.split(".")
                gz_file_name    = file[0]
                gz_file_id      = file[1]
                
                gz_file         = fn
                txt_file        = gz_file_name+"."+gz_file_id+".txt"
                
                file_for_decompress.append(gz_file)
                gunzip("./"+gz_file ,  "./"+txt_file)
                files_to_merge.append(txt_file)
                os.remove("./"+gz_file)
                print("|-REMOVE: "+gz_file)
        
        # Skip merge wtmp file as it is not text file
        if files_to_merge[0] == "wtmp":
            continue
        
        # Marge TXT files into one
        with open(files_to_merge[0]+"_merge.txt", 'w') as outfile:
            print("|-MERGE: "+files_to_merge[0]+"_merge.txt")
            for fname in list(reversed(files_to_merge)) :
                if os.path.getsize(fname) != 0:
                    print(" |--MERGE: "+ fname+" SIZE: "+str(os.path.getsize(fname)))
                    with open("./"+fname) as infile:
                        for line in infile:
                            outfile.write(line)
        print("--------------------------------------")
        print("\n")
                
### RUN Main ###
if __name__ == "__main__":
    main()