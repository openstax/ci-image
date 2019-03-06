# ci-image

This repository is autobuilt when `master` changes and is available at [DockerHub](https://hub.docker.com/r/openstax/ci-image)

## Instructions

```sh
# Build the image locally
docker build -t ci-image:latest .

# Start a container using the image
docker run -d --name my-container ci-image:latest

# Connect to the running container
docker exec -it my-container sh
```
