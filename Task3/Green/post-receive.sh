#!/bin/sh
GIT_WORK_TREE=/root/deploy/green.www/ git checkout -f

### Removing the image named 'my_image'

sudo docker rmi my_image

sudo docker build -t my_image /root/deploy/green.www/

sudo docker tag -f  my_image localhost:5000/my_image:latest

sudo docker push localhost:5000/my_image:latest

sudo docker stop $(docker ps -a -f "name=green*" -q)

sudo docker rm $(docker ps -a -f "name=green*" -q)

sudo docker pull localhost:5000/my_image:latest

sudo docker run -td -p 8080:8080 --name greenDocker localhost:5000/my_image

sudo docker exec -td greenDocker sh -c "node /src/main.js 8080"

