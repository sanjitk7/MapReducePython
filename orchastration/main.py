import sys
sys.path.append('../')

from read import input_and_chunk

if (__name__=="__main__"):
    chunks_n = int(input("Enter the number of chunks to split the text data into: "))
    input_and_chunk.input(5)
    
    