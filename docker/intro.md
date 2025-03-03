# Important Links
  Documentation:
  https://docs.docker.com/manuals/

  Docket Installation:
  https://docs.docker.com/engine/install/


# Introduction to Containers
    - What are Containers ?
        Containers are like small, portable boxes that hold everything an application needs to run—its code, settings, and required tools. They work the same way on any computer (laptop, cloud, or server), making apps faster, easier to move, and more reliable without worrying about system differences.

    - Containers vs Virtual Machines (VMs)
        Virtual Machine(E.g EC2 Instance):
            - Each VM has its own OS
            - Heavy, needs more memory & CPU
            - Takes minutes to boot
            - Requires more resources to scale
            - OS dependencies can cause issues
        Container(Docker):
            - Share the host OS kernel
            - Lightweight, uses less memory & CPU
            - Starts in seconds
            - Scales quickly with less overhead
            - Runs the same on any system

# Containerized Software
    - Docker
    - Rocket
    - Pod Man
    - Kubernetes

#  Install Docker on AWS EC2 Instance using Ubuntu AMI
    - Installing Docker (Linux)
      Follow this link to create a Docker container in Ubuntu
      https://docs.docker.com/engine/install/ubuntu/

      Follow this link to run docker as non-root user
      https://docs.docker.com/engine/install/linux-postinstall/

    - Quick Demo Run Apache2 (HTTPD) in a Docker Container
      Here is the website link https://www.free-css.com/free-css-templates/page296/finexo
      Follow this link to pull and run finxo website on docker: 
        a. Pull the image from where it is store(Docker Hub)
            - docker pull <image name>:tag +
              e.g docker pull httpd
                  docker pull aayodipe/finxo-website:v2
        b. confirm the image is on your docker machine:
            - docker images
        c. Create(run) a container from the image 
            - docker run -d -i -t --name <website-name> -p 80:80 <image-name>:tag
              e.g docker run -d -i -t --name http-webstite -p 80:80 httpd:latest
                  docker run -d -i -t --name fixo-website -p 80:80 aayodipe/finxo-website:v2
        d. Access the website from the browser
            - get the ip address of the host. 
                - copy it fromthe AWS ec2 instance console
                - curl ifconfig.me
            - Open in Your Browser and paste the ip address or dns name e.g
                    http://10.9.11.82:port          


# Working with Docker
    - What is Docker
      Docker is a tool that makes it easy to create, run, and manage containers. It packages applications with everything they need, so they run consistently across different systems—whether on a laptop, server, or the cloud

    - Docker Version
        * Docker CE (Community Edition):
          Free and open-source, for developers and small teams.

        * Docker EE (Enterprise Edition) 
          Paid version with extra security and support for businesses.
    
    - Docker Components

        * Docker CLI/Client
          The command-line tool used to interact with Docker (docker run, docker build).

        * Docker Daemon
          The background service that handles container creation, management, and execution. It listens to Docker CLI commands and manages containers.

        * Docker Engine
          The core software that runs and manages containers. It includes the Docker Daemon, CLI, and APIs.


# Main Docker Concepts
    - Docker Image
      A blueprint/template/Image(like that of AWS AMI) for a container; it contains the app, dependencies, and configurations needed to run

    - Docker Register
      A storage hub/virtual location where Docker images are stored and shared ( such as Docker Hub, AWS ECR, GitHub Container Registry).

    - Docker Container
      A running instance of a Docker image; it's lightweight, portable, and isolated.

# Working with Docker Image 
    You can start a docker container by building your own image from scratch. However, in most cases you will be starting with a pre-built image that contains some level of the application you want to run on the container, this is called base image. 

    - What is Base image?
      A Base Image is the starting point for building Docker images. It is a pre-built OS or application environment that provides the foundation for running applications inside a container
      Example of base images are:
       a. OS Image
            - ubuntu
            - debian
            - amazon linux
            - RHEL
            - Centos
        b Application Images:
            - python image
                For python application
            - terraform image
                For terraform application
            - sql image
                For SQL Applicaiton

    - Component of Docker image
        * Creation Date
        * Commands
        * Environment Variables
        * OS
        * Size of Image
         You can run the following command to see more information about the image you pull.
            docker inspect <image-name>:<tag>

    - Download a Docker Image
        docker run <image-name>
        docker pull <image-name>:latest e.g docker pull ubuntu:latest
        docker pull <image-name>:<tag-version> docker pull nginx:1.21

    
# Working with docker register
  - A Docker Registry stores and manages Docker images. The most common registry is Docker Hub.

  - Website for Docker register
    https://hub.docker.com/_/registry

  - Pull Publicly available Image from a Docker Hub 
    - search the image you want to pull e.g httpd
    - copy the command and paste in your docker cli 
    - verify the image is downloaded using the below command:
        docker images

  - Pull an Image from a private docker hub or docker hub you own
    - Log in to the docker hub
        From terminal run: 
            * docker login 
            * docker login -u <your-username> -p <your-password>

    - locate the image you want to pull and run
        docker pull docker pull <dockerhub-username>/<repository>:<tag>
        Alternatively, copy the command from the docker hub console and paste in your docker cli 
    - verify the image is downloaded using the below command:
        - docker images
        

    
# Working with docker container
  This is running the instance of the image. That is using the image to start a container( like virtual Machine)
  Follow the steps below to start a container from an image you already pulled. 
  a. Ensure to login before pulling private images
  b. Pull the image to your local machine or docker will authomatically pull the image.
  c. Run the image to create a container using:
    For public image:
        docker run <image-name> e.g docker run python
    For private or custom user images:
        docker run <dockerhub-username>/<repository>:<tag>
    Pull with flags:
        docker run -d i -t --name <application-name> -p host-port:container-port <image-name>:<tag>
        e.g docker run -dit --name finxo-website -p 80:80 aayodipe/finxo-website
            output: docker <log string number> e.g 7467524d88c0da19ee494551a2ee4a67dfdfc0579b70d1d3ae2f540491d0b226

        meaning of flags:
            -d: Run in detached mode
                e.g docker run httpd  
                This will block your terminal and you won't be able to run any other command                    
                docker run -d httpd
                detach the httpd container terminal from you host terminal.

            -i: Interactive shell  
                keep the container's input open so you can interract with it

            -t: Allocate a pseudo-TTY
                Give the container a virtual terminal so that it won't share same terminal with the host

            --name apache-server: 
              Assigns a name to the container
              
            -p 80:80: 
               Maps port 80 on the EC2 instance to port 80 inside the container
               Format -p <host_port>:<container_port>
               First is the host(ec2 Instance port)
               Second is the container port
    d: Access the application from a browser:
       Open your browser and paste the ip address or dns name e.g
                    http://10.9.11.82:port          


# COMMON IMAGE AND DOCKER CONTAINER COMMANDS:
  The simplest way to under this is my append --help to any command e.g
  docker --help
  docker images --help
  docker container --help


DOCKER IMAGES:

1. Pull an Image
    docker pull <image-name>
    
2. List all downloaded or pull
    docker images or docker image ls

3. Remove an image
    docker rmi <image-name>

4. Remove all images at once
    docker rmi -f $(docker images -aq)

5. Build new image form a docker file
    docker build -t <image_name>:<tag> .

6. Tag an image(Rename or Prepare ti push image to registery)
    docker tag <existing_image> <docker-username>/<new_image_name>:<tag>
    e.g docker tag aayodipe/finxo-website:v2 aayodipe/finxo-website:v1

7. Push Image to Docker Hub(Upload to storage)
   docker push <username>/<repository>:<tag>


8. Inspect Image Details (Metadata)
    Docker inspect <image-name>


DOCKER CONTAINERS:
1. Run a Container
    Used to start a new container
    docker run -dit --name mycontainer -p <host-port>:<container-port> <image-name>:<tag>

2. List Running Containers
   docker ps

3.  List All Containers Including Stopped Ones
    docker ps -a

4. Stop a Running Container
   docker stop <container_id or container-name>

5. Start a Stopped Container
   docker start <container_id or container-name>

6. Remove a Container:
   docker rm <container_id or container-name>

7. Enter a Running Container (Interactive Shell)
   docker exec -it <container-name> <shell-name>
   e.g docker exec -it myapp bash/zsh/sh
   Sample of command to run after accessing your container successfully
    a. cat /etc/os-release  --> This(The Name)will tell you will operating system your container is running on. That will determine the package manager to use
       Examples are: 
       Alpine: apk 
       e.g apk add --no-cache git
       Ubuntu/Debian: apt
       e.g apt update && apt install -y git
       Centos/RHEL: yum
       e.g yum install -y git or dnf install -y git

8.  Copy Files Between Host & Container
        - Copy file from host → container
          docker cp <file-name> <container-name>:</path/to/file>
          e.g docker cp myfile.txt myapp:/demo-app

        - Copy file from container → host
          docker cp <container-name>:</path/to/file> </path/to/container/file-name>
          e.g docker cp myapp:/demo-app .

9. View logs of a container
    docker logs <container-name>
    e.g docker logs myapp

10. Remove all container at once
   docker rm -f $(docker ps -aq)



# CONTAINER MANAGEMENT
Creating and managing multiple container can be tidious. Expectially in term of managing its:

- Networking
  By default, containers on the same host can communicate through Docker’s bridge network. However, for containers on different nodes (hosts), additional networking solutions are needed.


- Fault Tolerance
- Scaling and Load Balancing
- Security

To Manage a container effectively, we need container orchitration tools like:
- Docker Swarm
  https://docs.docker.com/reference/cli/docker/swarm/
- Kubernetes
  https://kubernetes.io/docs/concepts/
- Openshift
- Rancher
- Managed Orhectration e.g EKS , AKS, GKS etc
  https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html


# Working with Docker Swarm 
Use this commands to set up docker swarm

a. Set up three servers  for your docker swarms
   - One Master Node
   - two Worker Node

b. Install docker on all the three servers 
    - sudo apt update -y
    - sudo apt install -y docker.io
    - sudo systemctl enable docker
    - sudo systemctl start docker

c. Initialize Docker Swarm on the Manager Node
   - docker swarm init --advertise-addr <MANAGER-IP>
   - 
      This will generate a command that you will run on worker nodes
      e.g docker swarm join --token SWMTKN-1-xxxxxx <MANAGER-IP>:2<port>

d. Join Worker Nodes to the Swarm
    docker swarm join --token SWMTKN-1-xxxxxx <MANAGER-IP>:<port>

e. Verify nodes joined the Swarm (on Manager Node):
    docker nodes ls

f. Deploy a Service in Docker Swarm
   docker service create --name <service-name> --replicas <number-of-container> -p 8080:80 <image-name>
    *  --name my-nginx → Name of the service
    *  --replicas 3 → Run 3 instances (distributed across nodes)
    *  -p 8080:80 → Expose port 80 inside the container to port 8080 on the host
    *   nginx → Uses the official Nginx image

g. Check Running Services
    docker service ls

i. Verify Tasks (Containers) Running on Different Nodes
    docker service ps <service-name>

j. Access the Web Server Open a browser and visit:
   http://<ANY-NODE-IP>:8080


k. Scale Up or Down the Service
   docker service scale <service-name>=5

l. Stop the service
   docker service rm <service-name>

m. Remove a worker node (Run on Worker Node)
    docker swarm leave

n. Remove the Manager Node & Disable Swarm (Run on Manager)
   docker swarm leave --force
