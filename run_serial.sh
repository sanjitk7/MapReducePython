START_TIME=$(ruby -e 'puts (Time.now.to_f * 1000).to_i')

#!/bin/sh

echo "----------------------- INITIALISING MAPREDUCE SIMULATION ---------------------\n\n"

echo "ENTER THE NUMBER OF AVAILABLE NODES: "
read chunks

# RUN CHUNKING MODULE
echo "------------- INITIALISING CHUNKING SCRIPT OF INPUT TEXT FILE -------------\n"

cd orchestration
python main.py $chunks
cd ..

echo "------------- TERMINATING CHUNKING SCRIPT OF INPUT TEXT FILE -------------\n"

# CREATE VOLUME FOR DATA USAGE
echo "------------- CREATE VOLUME FOR DATA COMMUNICATION -------------\n"

docker volume create mapper_data
echo "----- DETAILS OF CREATED VOLUME: -----"
# docker volume ls
docker volume inspect mapper_data


# MAP PHASE

echo "------------- INITIALISING MAP PHASE -------------\n"

# Build Map Script Image
cd map
# sudo docker build -t map .
cd ..

# Create and Run Containes in Parallel
for (( i=1; i<=$chunks; i++ ))
do
	temp_name="map_node_$i"
    split_str="split_${i}_${chunks}.txt"
    echo "Process Creation:\nProcess Name: $temp_name\nSplitting and Mapping $split_str in Parallel\n"
    sh ./create_map_nodes.sh $split_str $temp_name $i $chunks
done


# COMBINE PHASE

# Build Combine Script Image
cd combine
# sudo docker build -t combine .
cd ..


echo "------------- INTERMEDIATE COMBINE PHASE INITIATION IN PARALLEL-------------\n"
docker container run --entrypoint /bin/sh -itd --mount source=mapper_data,destination=/usr/src/app/mapper_data --name combine_node combine:latest
docker exec -it combine_node python3 combine.py $chunks

echo "------------- MAP AND COMBINE PHASE TERMINATION -------------\n"


# REDUCE PHASE
cd reduce
# sudo docker build -t reduce .
cd ..

echo "------------- REDUCE PHASE INITIATION -------------\n"
for (( i=1; i<=$chunks; i++ ))
do
	temp_name="reduce_node_$i"
    split_str="combined_split_${i}_${chunks}.txt"
    echo "Process Creation:\nProcess Name: $temp_name\nReducing and Computing: $split_str in Parallel\n"
    sh ./create_reduce_nodes.sh $split_str $temp_name $i $chunks
done

wait
echo "------------- REDUCE PHASE TERMINATION -------------\n"



# COPY RESULT FILES BACK TO HOST

echo "------------- GETTING RESULT BACK TO MAIN NODE -------------\n"


SECONDS=0
REDUCED_FILES="$(docker exec -it reduce_node_1 find . -name "reduced_*" -printf '.' | wc -m)"
while [ $REDUCED_FILES != $chunks ]
do
echo "$SECONDS"
sleep .5
REDUCED_FILES="$(docker exec -it reduce_node_1 find . -name "reduced_*" -printf '.' | wc -m)"
echo "Result Files: $REDUCED_FILES and $chunks"
done


for (( i=1; i<=$chunks; i++ ))
do
reduced_str="reduced_${i}_${chunks}.txt"
echo $reduced_str
docker cp reduce_node_$i:/usr/src/app/mapper_data/$reduced_str ./data/reduced
done


python orchestration/combine_files.py

echo "------------- RESULT OBTAINED AND WRITTEN INTO HOST DATA FOLDER -------------\n"

echo "----------------------- TERMINATING MAPREDUCE SIMULATION ---------------------\n\n"

# COMPUTATION TIME CALC
END_TIME=$(ruby -e 'puts (Time.now.to_f * 1000).to_i')
COMP_TIME=$((END_TIME - START_TIME))
echo "****TOTAL COMPUTATION TIME OF THE ALGORITHM: $COMP_TIME ms **** "

wait