#!/bin/sh

echo "\nStarting input module...\n"
echo "Splitting the input document into chunks to distribute to various nodes in the distributed system.\n"
echo "Enter the number of chunks (ideally the number of nodes): "

read chunks

python input.py $chunks

# sudo docker build -t map .

docker images

for (( i=1; i<=$chunks; i++ ))
do
	temp_name="map_node_$i"
    split_str="split$i.txt"
    echo $temp_name
    echo $i
    docker container run --entrypoint /bin/sh -itd --name $temp_name map:latest
    docker cp data/$split_str $temp_name:/usr/src/app/data/data.txt
    docker exec -it $temp_name python3 map.py
done