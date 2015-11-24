#!/bin/sh
GIT_WORK_TREE=/root/deploy/blue.www/ git checkout -f

### Removing the image named 'my_image'

sudo docker rmi localhost:5000/my_image:latest

sudo docker build -t my_image /root/deploy/blue.www/

sudo docker tag -f my_image localhost:5000/my_image:latest

sudo docker push localhost:5000/my_image:latest

sudo docker stop $(docker ps -a -f "name=blue*" -q)

sudo docker rm $(docker ps -a -f "name=blue*" -q)

sudo docker pull localhost:5000/my_image:latest

sudo docker run -td -p 8081:8080 --name blueDocker localhost:5000/my_image

sudo docker exec -td blueDocker sh -c "node /src/main.js 8080"

