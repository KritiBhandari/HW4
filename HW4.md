HW #1 ADVANCED DOCKER
======================

**Kriti Bhandari**
**200065115**
**kbhanda**

*TASK 1*
--------

###INSTALLING DOCKER ON DIGITAL OCEAN DROPLET
     sudo apt-get update 
     sudo apt-get install wget 
     wget -qO- https://get.docker.com/ | sh
> 
> If Docker is already installed and an update is required do
>     service docker stop
> followed by the commands given above
> 
> Useful link: 
>     http://linoxide.com/linux-how-to/install-upgrade-docker-1-7/
> 
 

###DOCKER FILE
> A Docker file is created in order to build an image and then use it in order 
> to spin up a container using that image
> 
> The Dockerfile used to create the two containers is: 
> 
	FROM ubuntu:latest
    MAINTAINER Kriti Bhandari kbhanda@ncsu.edu
    RUN sudo apt-get -y update
    RUN sudo apt-get install -y socat
> 
> This creates an image using ubuntu from the global repositary and installs 
> socat and update on it as well
> 
> Build your image using the following command: 
    sudo docker build -t my_image .
> 

###CREATE DockerServer
> Using the Dockerfile a container is spun up called the DockerServer
    docker run --name DockerServer -td my_image 
> 
> Create a .txt file on this server which will be sent to the client side
    echo "Hi, I am a Docker Test File from the DockerServer" > TestFile.txt
> 

###CREATE DockerClient
> Another container needs to be created. It will also have a link to the 
> DockerServer Container
	docker run -td --link DockerServer:DockerServer --name DockerClient my_image 
> 
> Install 'curl' on this server 
    sudo apt-get install curl


###FILE ACCESS
> For the file transfer, socat is used on the DockerServer
    socat tcp-l:9001,reuseaddr,fork system:'cat /TestFile.txt’,nofork
> On the port 9001 the file would be make available
> The nofork option allows a child process to be created every time a
> curl is done from DockerClient


###Screencast
https://www.youtube.com/watch?v=_1jWEUwFoeM


*TASK 2*
--------

###INSTALLING DOCKER ON DIGITAL OCEAN DROPLET
> 
     sudo apt-get update 
     sudo apt-get install wget 
     wget -qO- https://get.docker.com/ | sh
> 
> If Docker is already installed and an update is required do
>     service docker stop
> followed by the commands given above
> 
> Useful link: 
>     http://linoxide.com/linux-how-to/install-upgrade-docker-1-7/
> 

###DOCKER COMPOSE INSTALLATION
> 
> Docker compose needs to be installed on both the droplets as follows:
> 
    sudo apt-get -y install python-pip
    sudo pip install docker-compose
> 
    chmod +x docker-compose.yml
> 

###DROPLET-1
> 
> There are two containers on this Droplet: The redis-server and
> the redis_ambassador
> They are both created using the docker-compose.yml file:
    redis:
        image: redis
        container_name: redis
    redis_ambassador:
        image: svendowideit/ambassador
        container_name: redis-ambassador
        links:
            - redis
        ports:
            - "6379:6379"
> The redis server is listening on 6379 of the container which is mapped to  
> the port 6379 of the droplet
> This starts both the containers and creates a link from the Ambassadro to 
> the redis server
> Run the docker-compose.yml file
    docker-compose up

###DROPLET-2
> This Droplet contains the other two containers: client and 
> redis_ambassador_client
> The docker-compose.yml used to create the ambassador is:
> 
    --- 
    redis_ambassador_client: 
      container_name: redis_ambassador_client
      environment: 
        - "REDIS_PORT_6379_TCP=tcp://*.*.*.*:6379"
      expose: 
        - "6379"
      image: svendowideit/ambassador
      ports: 
        - "6379:6379"
> 
> For the client container:
     sudo docker run -it --link redis_ambassador_client:redis --name client_redis relateiq/redis-cli
> 
> This creates the clien container and makes a link from itself to 
> the redis_ambassador_client
> Run the docker-compose.yml file
> 

###TEST
> For the testing phase, try set, get or ping using the Client Redis Cli
>  e.g.
    set abc cba
    get abc
returns
    cba

###Screencast
https://www.youtube.com/watch?v=lPRbD7nG2h4


*TASK 3*

###CREATE DIRECTORY STRUCTURE
> 
> Create the directory structure as given in the Workshop Deployments and 
> Depliting: 
	https://github.com/CSC-DevOps/Deployment
> Follow these steps:
    cd deploy/green.git
    git init --bare
    cd ..
    cd blue.git
    git init --bare
> 

###DOCKERFILE AND REGISTRY
> 
> A container is created for the registry which will later contain the 
> the image created from the specification in the Dockerfile 
> The Dockerfile contains the following: 
    FROM    centos:centos6
    # Enable EPEL for Node.js
    RUN     rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
    # Install Node.js and npm
    RUN     yum install -y npm
    # Bundle app source
    COPY . /src
    # Install app dependencies
    RUN cd /src; npm install
    EXPOSE  8080
    CMD ["node", "/src/main.js", "8080"]
> 
> The registry container is started as follows: 
    docker run -d -p 5000:5000 --restart=always --name registry registry:2
> 

###POST-RECEIVE HOOK
> 
> This hook 
> * Removes the images named 'my_image'
> * Creates new image called 'my_image' using the Dockerfile
> * Tags the image 
> * Pushes it to the local registry
> * Stops the containes with the specific name
> * Pulls the required image from the Registry
> * Creates a docker container using this image 
> * Starts the node.js application on the required port on this container
> 
> For each of the green and blue containers we can have separate pushes
> The following commands need to be executed for the hook to execute 
> 
    git add .
    git commit -m "Commit on Green"
    git push green master
> 
> The post-recieve file for both green and blue are given in the repo


###Screencast
https://www.youtube.com/watch?v=cVi01riGrR0&feature=youtu.be







