import sys
import docker
import subprocess
sys.path.append('../')

from read import input_and_chunk

chunks_n = int(sys.argv[1].strip())
# client = docker.from_env()

if (__name__=="__main__"):
    # Splitting input into chunks
    input_and_chunk.input(chunks_n)
    
    # Instantiating Docker Containers of Map Script (multiple nodes - multiple machines)
    # client.containers.run("map",["-itd", "--name", "map_node_1"])
    # client.containers.run("ubuntu",["echo","hi"])
    
    
    