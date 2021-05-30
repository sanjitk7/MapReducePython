#!/bin/sh

echo "\nStarting input module...\n"
echo "Splitting the input document into chunks to distribute to various nodes in the distributed system.\n"
echo "Enter the number of chunks (ideally the number of nodes): "

read chunks
cd orchestration
python main.py $chunks
cd ..

# build the mapper image
cd map
# sudo docker build -t map .
cd ..

docker images

docker volume create mapper_data
docker volume ls
docker volume inpsect mapper_data


# Map Phase
for (( i=1; i<=$chunks; i++ ))
do
	temp_name="map_node_$i"
    split_str="split_${i}_${chunks}.txt"
    echo $split_str
    echo $temp_name
    echo $i
    echo "$PATH"
    sh ./container_run.sh $split_str $temp_name $i $chunks &
done

# Combine Phase
cd combine
# sudo docker build -t combine .
cd ..

echo "starting combine container"
docker container run --entrypoint /bin/sh -itd --mount source=mapper_data,destination=/usr/src/app/mapper_data --name combine_node combine:latest
docker exec -it combine_node python3 combine.py $chunks

# Reduce Phase
cd reduce
# sudo docker build -t reduce .
cd ..

echo "starting reduce containers"
for (( i=1; i<=$chunks; i++ ))
do
	temp_name="reduce_node_$i"
    split_str="combined_split_${i}_${chunks}.txt"
    echo $split_str
    echo $temp_name
    echo $i
    echo "$PATH"
    sh ./container_run_2.sh $split_str $temp_name $i $chunks &
done