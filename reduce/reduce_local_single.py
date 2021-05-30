#!/usr/bin/env python3
import sys
import os.path
import time
from ast import literal_eval as make_tuple

total_chunks = int(sys.argv[1])

combined_files_path = "../data"
def count_combine_output_files():
    combined_split_counter = 0
    for root, dirs, files in os.walk(combined_files_path):
        for file in files:    
            if file.startswith('combined_split'):
                combined_split_counter += 1
    return combined_split_counter


def reduce():
    reduced_dict = {}
    for i in range(total_chunks):
        input_file_path = "../data/combined_split_"+str(i+1)+"_"+str(total_chunks) +".txt"
        print("input_file_path: ",input_file_path)
        with open(input_file_path, encoding = 'utf-8') as f:
            d = f.read()
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
                # reduce logic
                tuple_reduce_sum = sum(j_tuple[1]) # total the values of the list
                reduced_dict[j_tuple[0]] = tuple_reduce_sum
                
                # if j_tuple[0] not in combined_dict:
                #     # creates single item list in value
                #     reduced_dict[j_tuple[0]] = [j_tuple[1]]
                # else:
                #     combined_dict[j_tuple[0]].append(j_tuple[1])
                
    # print("\ncombined: ",combined_dict,"\n")
    with open("../data/final_reduced_data.txt","w",encoding="utf-8") as ff:
        tup_view = reduced_dict.items()
        tup_list = list(tup_view)    
        # print(tup_list)
        for y in tup_list:
            ff.write(str(y)+"\n")            
            

flag = False
while not flag:
    print("number of combine.py's output files = ",count_combine_output_files())
    if (count_combine_output_files()==total_chunks):
        reduce()
        break
    time.sleep(3)
