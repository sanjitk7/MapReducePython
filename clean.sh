docker kill $(docker ps -q)
docker container prune -f

docker volume rm mapper_data -f
docker volume prune