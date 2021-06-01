#!/usr/bin/env python3
import sys
import datetime
begin_time = datetime.datetime.now()
output_no = sys.argv[1]
total_chunks = sys.argv[2]
print(output_no)
data_location = "./mapper_data/"
input_file_path = data_location+"split_"+str(output_no)+"_"+str(total_chunks)+".txt"
# output_file_location = "./mapped_data/mapped_data_"
mapped_dict = {}
try:
    print("input file path in map.py of node ",output_no,input_file_path)
    with open(input_file_path, encoding = 'utf-8') as f:
        d = f.read()
        l = d.split(" ")
        for x in l:
                if x not in mapped_dict:
                    mapped_dict[x] = 1
                else:
                    mapped_dict[x] = mapped_dict[x] + 1
        with open(data_location+"mapped_"+str(output_no)+"_"+str(total_chunks)+ ".txt","w", encoding = "utf-8") as mapped_data_file:
            tup_view = mapped_dict.items()
            tup_list = list(tup_view)
            for y in tup_list:
                mapped_data_file.write(str(y)+"\n")
    end_time = datetime.datetime.now()
    print("COMPUTATION TIME: MAP NODE "+str(output_no)+" = "+str(end_time-begin_time))
                
except IOError as e:
    print(IOError,e)