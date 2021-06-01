timestamp() {
  date +"%T"
}
echo "Map Process $2 Start Time:" 
timestamp
docker container run --entrypoint /bin/sh -itd --mount source=mapper_data,destination=/usr/src/app/mapper_data --name $2 map:latest
docker cp data/$1 $2:/usr/src/app/mapper_data/$1
docker exec $2 python3 map.py $3 $4