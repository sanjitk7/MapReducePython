#!/usr/bin/env python3
import sys
import os.path
import time
from ast import literal_eval as make_tuple

total_chunks = int(sys.argv[1])

mapped_files_path = "./mapper_data"
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
        input_file_path = "./mapper_data/mapped_"+str(i+1)+"_"+str(total_chunks) +".txt"
        print("input_file_path: ",input_file_path)
        with open(input_file_path, encoding = 'utf-8') as f:
            d = f.read()
            # read each line - tuple strings
            tuples_list = d.split("\n")
            # print(tuples_list)
            count = 0
            for j in tuples_list:
                count+=1
                # parse the tuple
                # print("j count:",count)
                try:
                    j_tuple = make_tuple(j)
                except:
                    print("j: ", j)
                # print(j_tuple,type(j_tuple))
                if j_tuple[0] not in combined_dict:
                    # creates single item list in value
                    combined_dict[j_tuple[0]] = [j_tuple[1]]
                else:
                    combined_dict[j_tuple[0]].append(j_tuple[1])
    # print("\ncombined: ",combined_dict,"\n")
    with open("./mapper_data/combined_data.txt","w",encoding="utf-8") as ff:
        tup_view = combined_dict.items()
        tup_list = list(tup_view)    
        # print(tup_list)
        for y in tup_list:
            ff.write(str(y)+"\n")            
            

flag = False
while not flag:
    print(count_map_output_files())
    if (count_map_output_files()==total_chunks):
        combine()
        break
    time.sleep(3)
