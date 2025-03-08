# Building an Image from Docker File

1. Create a Dockerfile file in a repository of your choice and cd into it
   Example: 
    mkdir frontend && cd frontend

2. Create a Dockerfile file( with no extension) inside the repository
   touch Dockerfile

3. Inside the file with your dockerile commands. See examples in dockerfiles repositorys
4. build the docker image from the Dockerfile
    docker build -t <image-name> .
    E.g docker build -t frontend-image .
    The above biuld an image called frontend-image in same respository you can currently located. Use pwd to check the current repository
5. Check if the image was built successfully
   docker images

# Create a container form the image

1. Run docker images to see the image you want to use for the container and check a container is not already created with same name and port
   a. check the image name
      docker image
   b. check if container with same name not already exist
      docker ps 
2. Create the containere:
   docker run -d -t -i --name <name-of-container> -p <hostPort:containerPort> <image-name>
   e.g docker run -dti --name frontend-container -p 80:80 frontend-image

3. Test the container
   http://<ip-address>:<hostPort>
   e.g http://19.09.4.20:80 
       localhost:80


# Send Image to Docker-hub

1. Login to dockerhub
   docker login
   The above command will give you some instruction, follow the instruction to login

2. Tag your image
   docker tag <image-name> <dockerhub-user-name/image-name>:<version>
   e.g docker tag frontend-image mydockerhubusername/frontend-image:latest

3. Check the new tag name
   docker images
   After running the command docker images, you shoud see the image with "mydockerhubusername/frontend-image" with a tag of "latest"

4. Push the images to Docker Hub
   docker push <dockerhub-user-name/image-name>:<version>
   e.g docker push mydockerhubusername/frontend-image:latest

5. Check the new image from your dockerhub acount
   