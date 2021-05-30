timestamp() {
  return date +"%T"
}

echo "from inside container_run_2:$1 $2 $3 $4"
START=timestamp
echo "start time: $START"
docker container run --entrypoint /bin/sh -itd --mount source=mapper_data,destination=/usr/src/app/mapper_data --name $2 reduce:latest
docker exec $2 python3 reduce.py $3 $4