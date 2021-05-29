echo "from inside container_run:$1 $2 $3"
docker container run --entrypoint /bin/sh -itd --mount source=mapper_data,destination=/usr/src/app/mapper_data --name $temp_name map:latest
docker cp data/$split_str $temp_name:/usr/src/app/mapper_data/$split_str
docker exec -it $temp_name python3 map.py $i $chunks