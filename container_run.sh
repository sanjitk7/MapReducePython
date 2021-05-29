timestamp() {
  return date +"%T"
}

echo "from inside container_run:$1 $2 $3 $4"
START=timestamp
echo "start time: $START"
docker container run --entrypoint /bin/sh -itd --mount source=mapper_data,destination=/usr/src/app/mapper_data --name $2 map:latest
docker cp data/$1 $2:/usr/src/app/mapper_data/$1
docker exec $2 python3 map.py $3 $4