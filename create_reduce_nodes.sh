timestamp() {
  date +"%T"
}
echo "Reduce Process $2 Start Time:" 
timestamp
docker container run --entrypoint /bin/sh -itd --mount source=mapper_data,destination=/usr/src/app/mapper_data --name $2 reduce:latest
docker exec $2 python3 reduce.py $3 $4