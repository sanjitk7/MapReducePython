#!/usr/bin/env python3
import sys
import os.path
import time
from ast import literal_eval as make_tuple

def file_len(fname):
    with open(fname) as f:
        for i, l in enumerate(f):
            pass
    return i + 1

total_chunks = int(sys.argv[1])

def list_chunks(l, n):
    n = max(1, n)
    return [l[i:i+n] for i in range(0, len(l), n)]

mapped_files_path = "../data"

def count_map_output_files():
    mapped_counter = 0
    for root, dirs, files in os.walk(mapped_files_path):
        for file in files:    
            if file.startswith('mapped'):
                mapped_counter += 1
    return mapped_counter

def combine():
    combined_dict = {}
    for i in range(total_chunks):
        input_file_path = "../data/mapped_"+str(i+1)+"_"+str(total_chunks) +".txt"
        print("input_file_path: ",input_file_path)
        with open(input_file_path, encoding = 'utf-8') as f:
            d = f.read()
            # read each line - tuple strings
            tuples_list = d.split("\n")
            # print(tuples_list)
            for j in tuples_list:
                # parse the tuple
                try:
                    j_tuple = make_tuple(j)
                except:
                    print("**** j is **** :",j)
                if j_tuple[0] not in combined_dict:
                    combined_dict[j_tuple[0]] = [j_tuple[1]]
                else:
                    combined_dict[j_tuple[0]].append(j_tuple[1])
    
    # creating a list of tuples to write to reduce nodes
    tup_view = combined_dict.items()
    tup_list = list(tup_view)

    tup_list_chunks = list_chunks(tup_list,total_chunks)
    
    for i in range(total_chunks):
        combined_output_path = "../data/combined_split_" + str(i+1)+"_"+ str(total_chunks) + ".txt"
        tup_list_chunk = tup_list_chunks[i]
        with open(combined_output_path,"w",encoding="utf-8") as ff:
            # print(tup_list)
            for y in tup_list_chunk:
                ff.write(str(y)+"\n")            
            

flag = False
while not flag:
    print(count_map_output_files())
    if (count_map_output_files()==total_chunks):
        combine()
        break
    time.sleep(3)